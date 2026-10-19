#!/usr/bin/env python3
import struct, sys, os, re

def u32(b, o): return struct.unpack_from("<I", b, o)[0]
def i32(b, o): return struct.unpack_from("<i", b, o)[0]
def u64(b, o): return struct.unpack_from("<Q", b, o)[0]

class Unit:
    def __init__(self, data):
        self.b = data
        assert data[:8] == b"qv4cdata", "bad magic"
        self.version = u32(data, 8)
        self.qt = u32(data, 12)
        self.ts = struct.unpack_from("<q", data, 16)[0]
        self.unitSize = u32(data, 24)
        self.flags = u32(data, 68)
        self.nStrings = u32(data, 72)
        self.stringTable = u32(data, 76)
        self.nFunctions = u32(data, 80)
        self.functionTable = u32(data, 84)
        self.nLookups = u32(data, 88)
        self.lookupTable = u32(data, 92)
        self.sourceFileIndex = u32(data, 124)
        self.finalUrlIndex = u32(data, 128)
        self.nImports = u32(data, 132)
        self.importTable = u32(data, 136)
        self.nObjects = u32(data, 140)
        self.objectTable = u32(data, 144)

    def string(self, i):
        if i < 0 or i >= self.nStrings: return ""
        off = u32(self.b, self.stringTable + i * 4)
        n = struct.unpack_from("<i", self.b, off)[0]
        return self.b[off + 4: off + 4 + n * 2].decode("utf-16-le", "replace")

    def source_file(self):
        return self.string(self.sourceFileIndex)

    def imports(self):
        out = []
        for i in range(self.nImports):
            o = self.importTable + i * 24
            typ, uri, qual, maj, mnr = struct.unpack_from("<IIiii", self.b, o)
            out.append(dict(type=typ, uri=self.string(uri), qualifier=self.string(qual),
                            major=maj, minor=mnr))
        return out

    def object(self, i):
        return Obj(self, u32(self.b, self.objectTable + i * 4), i)

    def function(self, off):
        f = self.b[off:off + 72]
        return dict(offset=off, codeOffset=u64(f, 0), codeSize=u64(f, 8),
                    nameIndex=u32(f, 16), nFormals=u32(f, 20),
                    formalsOffset=u32(f, 24), nLocals=u32(f, 28),
                    nInnerFunctions=u32(f, 36), location=u32(f, 40))

class Obj:
    def __init__(self, unit, off, index):
        b = unit.b; self.unit = unit; self.index = index; self.off = off
        self.inheritedType = u32(b, off)
        self.idName = u32(b, off + 4)
        flagsWord = u32(b, off + 8)
        self.flags = flagsWord & 0x7fff
        self.idIndex = (flagsWord >> 16) & 0xffff
        self.nFunctions = u32(b, off + 16); self.funcTable = u32(b, off + 20)
        self.nProperties = u32(b, off + 24); self.propTable = u32(b, off + 28)
        self.nAliases = u32(b, off + 32); self.aliasTable = u32(b, off + 36)
        self.nEnums = u32(b, off + 40); self.enumTable = u32(b, off + 44)
        self.nSignals = u32(b, off + 48); self.signalTable = u32(b, off + 52)
        self.nBindings = u32(b, off + 56); self.bindTable = u32(b, off + 60)
        self.location = u32(b, off + 72)

    def functions(self):
        out = []
        for i in range(self.nFunctions):
            idx = u32(self.unit.b, self.off + self.funcTable + i * 4)
            off = u32(self.unit.b, self.unit.functionTable + idx * 4)
            out.append(self.unit.function(off))
        return out

    def properties(self):
        out = []
        for i in range(self.nProperties):
            o = self.off + self.propTable + i * 16
            name, tf, custom, loc = struct.unpack_from("<IIII", self.unit.b, o)
            out.append(dict(nameIndex=name, type=tf & 0x7fffffff,
                            readonly=(tf >> 31) & 1, customIndex=custom))
        return out

    def aliases(self):
        out = []
        for i in range(self.nAliases):
            o = self.off + self.aliasTable + i * 20
            nf, tgt, prop, loc, refloc = struct.unpack_from("<IIIII", self.unit.b, o)
            out.append(dict(nameIndex=nf & 0x1fffffff, flags=nf >> 29,
                            targetId=tgt & 0x7fffffff,
                            aliasToLocalAlias=bool(tgt >> 31),
                            encodedMetaPropertyIndex=i32(self.unit.b, o + 8),
                            location=loc, referenceLocation=refloc))
        return out

    def enums(self):
        out = []
        for i in range(self.nEnums):
            eo = self.off + u32(self.unit.b, self.off + self.enumTable + i * 4)
            name, n, loc = struct.unpack_from("<III", self.unit.b, eo)
            vals = []
            for j in range(n):
                vo = eo + 12 + j * 12
                vals.append((u32(self.unit.b, vo), i32(self.unit.b, vo + 4)))
            out.append(dict(nameIndex=name, values=vals))
        return out

    def signals(self):
        out = []
        for i in range(self.nSignals):
            so = self.off + u32(self.unit.b, self.off + self.signalTable + i * 4)
            name, n, loc = struct.unpack_from("<III", self.unit.b, so)
            params = []
            for j in range(n):
                po = so + 12 + j * 16
                pname, ptype, pcustom, ploc = struct.unpack_from("<IIII", self.unit.b, po)
                params.append(pname)
            out.append(dict(nameIndex=name, params=params))
        return out

    def bindings(self):
        out = []
        for i in range(self.nBindings):
            o = self.off + self.bindTable + i * 32
            prop, ft = struct.unpack_from("<II", self.unit.b, o)
            flags = ft & 0xffff; typ = (ft >> 16) & 0xffff
            val = u64(self.unit.b, o + 8)
            out.append(dict(prop=prop, flags=flags, type=typ, value=val,
                            scriptIndex=val & 0xffffffff, objectIndex=val & 0xffffffff,
                            bool=(val & 0xff) != 0,
                            number=struct.unpack("<d", struct.pack("<Q", val))[0],
                            commentIndex=(val >> 32) & 0xffffffff,
                            trNumber=struct.unpack("<i", struct.pack("<I", (val >> 32) & 0xffffffff))[0],
                            strIndex=u32(self.unit.b, o + 16)))
        return out

class Renderer:
    PATH_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$")

    def __init__(self, u):
        self.u = u
        self.objs = [u.object(i) for i in range(u.nObjects)]
        self.consumed = set()
        self.unknown = 0
        self.by_id = {}
        for o in self.objs:
            if o.idIndex != 0xffff:
                self.by_id[o.idIndex] = o
        self.alias_names = set()
        self.id_names = set()
        for o in self.objs:
            if o.idName:
                self.id_names.add(u.string(o.idName))
            for a in o.aliases():
                self.alias_names.add(u.string(a["nameIndex"]))
        self.import_uris = set(im["uri"] for im in u.imports())

    def s(self, i): return self.u.string(i)

    def esc(self, s):
        return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")

    def ext(self, o):
        return self.s(o.inheritedType) or "Item"

    def render(self):
        body = self.obj_body(self.objs[0], 1)
        return self.ext(self.objs[0]) + " {\n" + body + "\n}"

    def obj_body(self, o, ind):
        pad = "    " * ind
        out = []
        if o.idName:
            out.append(pad + "id: " + self.s(o.idName))
        for p in o.properties():
            out.append(pad + self.prop_decl(p))
        for a in o.aliases():
            out.append(pad + self.alias_decl(a))
        for e in o.enums():
            vals = ", ".join(self.s(n) + " = " + str(v) for n, v in e["values"])
            out.append(pad + "enum " + self.s(e["nameIndex"]) + " { " + vals + " }")
        for sig in o.signals():
            out.append(pad + "signal " + self.s(sig["nameIndex"]) + "(" +
                       ", ".join(self.s(pp) for pp in sig["params"]) + ")")
        for f in o.functions():
            formals = []
            for k in range(f["nFormals"]):
                formals.append(self.s(u32(self.u.b, f["offset"] + f["formalsOffset"] + k * 4)))
            out.append(pad + "function " + self.s(f["nameIndex"]) + "(" +
                       ", ".join(formals) + ") { /* TODO: bytecode only */ }")
        binds = o.bindings()
        i = 0
        while i < len(binds):
            bd = binds[i]
            prop = self.s(bd["prop"])
            if bd["flags"] & 0x20:
                items = []
                while i < len(binds) and (binds[i]["flags"] & 0x20) and self.s(binds[i]["prop"]) == prop:
                    v = self.value(bd=binds[i], ind=ind)
                    if v is not None: items.append(v)
                    i += 1
                out.append(pad + prop + ": [")
                out.extend(items)
                out.append(pad + "]")
                continue
            if bd["type"] in (8, 9):
                oi = bd["objectIndex"]
                tgt = self.objs[oi] if oi < len(self.objs) else None
                if tgt is None:
                    i += 1; continue
                if bd["type"] == 9:
                    out.append(pad + prop + " {")
                    out.append(self.obj_body(tgt, ind + 1))
                    out.append(pad + "}")
                else:
                    for ib in tgt.bindings():
                        ip = self.s(ib["prop"])
                        if ib["flags"] & 0x1:
                            ip = self.handler_name(ip)
                        v = self.value(bd=ib, ind=ind)
                        if v is not None:
                            out.append(pad + prop + "." + ip + ": " + v.strip())
                i += 1
                continue
            if bd["type"] == 7:
                oi = bd["objectIndex"]
                if oi < len(self.objs):
                    sub = self.objs[oi]
                    if self.is_implicit_component(sub):
                        child = self.component_child(sub)
                        if child is not None:
                            val = self.obj_inline(child, ind)
                            if prop:
                                out.append(pad + prop + ": " + val.lstrip())
                            else:
                                out.append(val)
                            i += 1
                            continue
                    if prop:
                        out.append(pad + prop + ": " + self.ext(sub) + " {")
                        out.append(self.obj_body(sub, ind + 1))
                        out.append(pad + "}")
                    else:
                        out.append(pad + self.ext(sub) + " {")
                        out.append(self.obj_body(sub, ind + 1))
                        out.append(pad + "}")
                i += 1
                continue
            if bd["flags"] & 0x1:
                src = self.s(bd["strIndex"]).strip() if bd["strIndex"] < self.u.nStrings else ""
                if src:
                    out.append(pad + self.handler_name(prop) + ": " + src)
                else:
                    out.append(pad + self.handler_name(prop) + ": { /* TODO(compiled) */ }")
                i += 1
                continue
            v = self.value(bd=bd, ind=ind)
            if v is not None:
                out.append(pad + prop + ": " + v.strip())
            i += 1
        return "\n".join(out)

    def is_implicit_component(self, o):
        t = self.ext(o)
        return bool(o.flags & 1) and not o.idName and (t == "Component" or t.endswith(".Component"))

    def component_child(self, o):
        for b in o.bindings():
            if b["type"] == 7 and b["objectIndex"] < len(self.objs):
                return self.objs[b["objectIndex"]]
        return None

    def obj_inline(self, o, ind):
        pad = "    " * ind
        return self.ext(o) + " {\n" + self.obj_body(o, ind + 1) + "\n" + pad + "}"

    def alias_decl(self, a):
        name = self.s(a["nameIndex"])
        ro = "readonly " if a["flags"] & 1 else ""
        target = self.by_id.get(a["targetId"])
        if target is None:
            return ro + "property alias " + name + ": /* unresolved id " + str(a["targetId"]) + " */"
        tname = self.s(target.idName)
        if a["encodedMetaPropertyIndex"] == -1:
            return ro + "property alias " + name + ": " + tname
        prop = self.alias_prop_name(a, target)
        if not prop:
            return ro + "property alias " + name + ": " + tname + " /* metaIndex=" + str(a["encodedMetaPropertyIndex"]) + " */"
        return ro + "property alias " + name + ": " + tname + "." + prop

    def alias_prop_name(self, a, target):
        tprops = set(self.s(b["prop"]) for b in target.bindings() if b["prop"])
        a_name = self.s(a["nameIndex"])
        ni = a["nameIndex"]
        best = None
        for j in range(max(0, ni - 8), min(self.u.nStrings, ni + 9)):
            s = self.s(j)
            if not self.PATH_RE.match(s):
                continue
            if s in self.alias_names or s in self.id_names or s in self.import_uris:
                continue
            if s.startswith("expression for "):
                continue
            root = s.split(".")[0]
            name_hit = 0 if a_name.lower().endswith(root.lower()) else 1
            score = (name_hit, 0 if root in tprops else 1, abs(j - ni), j)
            if best is None or score < best[0]:
                best = (score, s)
        return best[1] if best else None

    def handler_name(self, prop):
        if prop.startswith("on") and len(prop) > 2 and prop[2].isupper():
            return prop
        return "on" + prop[:1].upper() + prop[1:]

    def prop_decl(self, p):
        tmap = {0: "var", 1: "variant", 2: "int", 3: "bool", 4: "real", 5: "string",
                6: "url", 7: "color", 8: "font", 9: "time", 10: "date", 11: "dateTime",
                12: "rect", 13: "point", 14: "size", 15: "vector2d", 16: "vector3d",
                17: "vector4d", 18: "matrix4x4", 19: "quaternion"}
        t = p["type"]
        if t >= 20:
            pt = "list<" + self.s(p["customIndex"]) + ">" if t == 21 else self.s(p["customIndex"])
        else:
            pt = tmap.get(t, "var")
        return ("readonly " if p["readonly"] else "") + "property " + pt + " " + self.s(p["nameIndex"])

    def value(self, bd, ind):
        t = bd["type"]
        pad = "    " * (ind + 1)
        if t == 1: return "true" if bd["bool"] else "false"
        if t == 2:
            n = bd["number"]
            return str(int(n)) if n == int(n) else repr(n)
        if t == 3:
            return '"' + self.esc(self.s(bd["strIndex"])) + '"'
        if t in (4, 5):
            txt = self.esc(self.s(bd["strIndex"]))
            comment = self.s(bd["commentIndex"]) if bd["commentIndex"] else ""
            if comment or bd["trNumber"] >= 0:
                args = ['"%s"' % txt]
                args.append('"%s"' % self.esc(comment))
                if bd["trNumber"] >= 0: args.append(str(bd["trNumber"]))
                return "qsTr(" + ", ".join(args) + ")"
            return 'qsTr("%s")' % txt
        if t == 6:
            src = self.s(bd["strIndex"])
            if src.strip():
                body = src.strip("\n")
                if bd["flags"] & 0x1 and "\n" in body:
                    return "\n" + body
                return body
            fname = ""
            if bd["scriptIndex"] < self.u.nFunctions:
                off = u32(self.u.b, self.u.functionTable + bd["scriptIndex"] * 4)
                fname = self.s(self.u.function(off)["nameIndex"])
            self.unknown += 1
            label = fname.replace("expression for ", "")
            return "/* TODO(compiled): %s */ undefined" % label
        if t == 7:
            oi = bd["objectIndex"]
            if oi < len(self.objs):
                self.consumed.add(oi)
                sub = self.objs[oi]
                first = pad + self.ext(sub) + " {"
                return first + "\n" + self.obj_body(sub, ind + 1) + "\n" + pad + "}"
            return "/* TODO: object */ undefined"
        if t == 8 or t == 9:
            return None
        return "/* TODO: type %d */ undefined" % t

def render_imports(u):
    out = []
    for im in u.imports():
        if im["type"] == 1:
            if im["qualifier"] == "QmlInternals":
                continue
            if im["qualifier"]:
                out.append("import %s %d.%d as %s" % (im["uri"], im["major"], im["minor"], im["qualifier"]))
            elif im["major"] or im["minor"]:
                out.append("import %s %d.%d" % (im["uri"], im["major"], im["minor"]))
            elif im["uri"]:
                out.append("import " + im["uri"])
        elif im["type"] == 2:
            out.append('import "%s"' % im["uri"])
        elif im["type"] == 3:
            out.append('import "%s" as %s' % (im["uri"], im["qualifier"] or "Script"))
    return out


def render_file(path):
    u = Unit(open(path, "rb").read())
    r = Renderer(u)
    out = render_imports(u)
    if out:
        out.append("")
    out.append(r.render())
    return "\n".join(out) + "\n", u, r


def render_js(path):
    u = Unit(open(path, "rb").read())
    out = render_imports(u)
    if out:
        out.append("")
    for i in range(u.nFunctions):
        f = u.function(u32(u.b, u.functionTable + i * 4))
        name = u.string(f["nameIndex"])
        formals = []
        for k in range(f["nFormals"]):
            formals.append(u.string(u32(u.b, f["offset"] + f["formalsOffset"] + k * 4)))
        if not name or name.startswith("%"):
            continue
        out.append("function %s(%s) { /* TODO(compiled): %d bytes */ }" % (name, ", ".join(formals), f["codeSize"]))
    return "\n".join(out) + "\n", u


def emit(path):
    data = open(path, "rb").read()
    u = Unit(data)
    src = u.source_file()
    if src.endswith(".js"):
        txt, u = render_js(path)
        return txt, src, 0
    txt, u, r = render_file(path)
    return txt, src, r.unknown


def out_path(src, digest, outdir):
    rel = src
    if rel.startswith("qrc:/"):
        rel = rel[5:]
    elif rel.startswith("qrc:"):
        rel = rel[4:]
    elif rel.startswith("file://"):
        path = rel[7:]
        idx = path.find("/qml/")
        rel = ("qt/" + path[idx + 5:]) if idx >= 0 else os.path.basename(path)
    elif rel.startswith("file:"):
        path = rel[5:]
        idx = path.find("/qml/")
        rel = ("qt/" + path[idx + 5:]) if idx >= 0 else os.path.basename(path)
    rel = rel.lstrip("/").replace("..", "_")
    if not rel:
        rel = "unknown.qml"
    dst = os.path.join(outdir, rel)
    if os.path.exists(dst):
        stem, ext = os.path.splitext(rel)
        dst = os.path.join(outdir, stem + "__" + digest[:8] + ext)
    return dst


def main(argv):
    outdir = None
    args = []
    it = iter(argv)
    for a in it:
        if a == "--out":
            outdir = next(it)
        else:
            args.append(a)
    if outdir:
        os.makedirs(outdir, exist_ok=True)
        manifest = []
        total_unknown = 0
        for p in args:
            txt, src, unknown = emit(p)
            digest = os.path.basename(p).split(".")[0]
            dst = out_path(src, digest, outdir)
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            with open(dst, "w", encoding="utf-8") as fh:
                fh.write(txt)
            manifest.append((src, os.path.relpath(dst, outdir), unknown))
            total_unknown += unknown
        with open(os.path.join(outdir, "MANIFEST.tsv"), "w", encoding="utf-8") as fh:
            fh.write("source\toutput\tunknown_expressions\n")
            for row in sorted(manifest):
                fh.write("\t".join(str(x) for x in row) + "\n")
        print("wrote %d files to %s, unknown expressions: %d" % (len(manifest), outdir, total_unknown))
        return
    for p in args:
        txt, src, unknown = emit(p)
        print("// ==== " + src + "  (unknown expressions: %d)" % unknown)
        print(txt)


if __name__ == "__main__":
    main(sys.argv[1:])
