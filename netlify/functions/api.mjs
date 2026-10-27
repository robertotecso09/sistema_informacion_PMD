import { getStore } from "@netlify/blobs";
import crypto from "node:crypto";
import seed from "../../data/seed.json" with { type: "json" };

const J = (d, s = 200) => new Response(JSON.stringify(d), { status: s, headers: { "content-type": "application/json" } });
const E = (m, s = 400) => J({ error: m }, s);
const secret = () => Netlify.env.get("SESSION_SECRET") || "pmd:" + (Netlify.env.get("ADMIN_PASSWORD") || "");
const sign = (p) => crypto.createHmac("sha256", secret()).update(p).digest("base64url");
const token = (u, r) => { const p = Buffer.from(JSON.stringify({ u, r, e: Date.now() + 12 * 36e5 })).toString("base64url"); return p + "." + sign(p); };
const same = (a, b) => a.length === b.length && crypto.timingSafeEqual(Buffer.from(a), Buffer.from(b));
const hash = (pw) => { const s = crypto.randomBytes(8).toString("hex"); return s + "$" + crypto.scryptSync(pw, s, 64).toString("hex"); };
const check = (pw, h) => { const [s, k] = (h || "$").split("$"); return !!k && same(crypto.scryptSync(pw, s, 64).toString("hex"), k); };

function session(req) {
  const [p, s] = (req.headers.get("authorization") || "").replace("Bearer ", "").split(".");
  if (!p || !s || !same(sign(p), s)) return null;
  const d = JSON.parse(Buffer.from(p, "base64url"));
  return d.e > Date.now() ? d : null;
}

// Validación (misma lógica que en el navegador): cantidades solo números, textos con longitud mínima.
const NUM = /^\d{1,9}(\.\d{1,2})?$/;
function valida(d) {
  const t = (x) => typeof x === "string" && x.trim().length >= 10 && x.length <= 800;
  const c = (x) => typeof x === "string" && NUM.test(x.trim());
  if (d.modo === "sin") return t(d.motivo) ? null : "Explique el motivo (mínimo 10 caracteres).";
  if (d.modo === "unico") return c(d.unico?.c) && t(d.unico?.t) ? null : "Revise la cantidad (solo números) y la descripción.";
  if (d.modo === "periodos") return Array.isArray(d.p) && d.p.length === 3 && d.p.every((x) => c(x?.c) && t(x?.t)) ? null : "Revise cantidad (solo números) y descripción de los 3 periodos.";
  return "Indique cómo reporta los datos.";
}

export default async (req) => {
  const db = getStore({ name: "pmd", consistency: "strong" });
  if (!(await db.get("lineas"))) { await db.setJSON("lineas", seed.lineas); await db.setJSON("usuarios", seed.usuarios); }
  const ruta = new URL(req.url).pathname.replace(/^\/api\/?/, "");
  const body = req.method === "GET" ? {} : await req.json().catch(() => ({}));

  if (ruta === "login") {
    const { usuario = "", password = "" } = body;
    const admin = Netlify.env.get("ADMIN_PASSWORD");
    if (usuario === "admin") return admin && same(password, admin) ? J({ token: token("admin", "admin"), rol: "admin", nombre: "Administrador" }) : E(admin ? "Usuario o contraseña incorrectos." : "Falta configurar ADMIN_PASSWORD en Netlify.", 401);
    const us = await db.get("usuarios", { type: "json" });
    const u = us[usuario];
    return u && check(password, u.hash) ? J({ token: token(usuario, "user"), rol: "user", nombre: u.nombre }) : E("Usuario o contraseña incorrectos.", 401);
  }

  const s = session(req);
  if (!s) return E("Sesión expirada.", 401);
  const lineas = await db.get("lineas", { type: "json" });

  if (ruta === "mis-lineas" && s.r === "user") return J({ lineas: lineas.filter((l) => l.area === s.u), respuestas: (await db.get("resp:" + s.u, { type: "json" })) || {} });

  if (ruta === "respuesta" && s.r === "user") {
    const l = lineas.find((x) => x.id === body.id && x.area === s.u);
    if (!l) return E("Esa línea no está asignada a su usuario.", 403);
    const m = valida(body.datos || {});
    if (m) return E(m);
    const r = (await db.get("resp:" + s.u, { type: "json" })) || {};
    r[l.id] = { ...body.datos, fecha: new Date().toISOString() };
    await db.setJSON("resp:" + s.u, r);
    return J({ ok: true, fecha: r[l.id].fecha });
  }

  if (s.r !== "admin") return E("No autorizado.", 403);
  const us = await db.get("usuarios", { type: "json" });

  if (ruta === "admin/todo") {
    const respuestas = {};
    for (const u of Object.keys(us)) Object.assign(respuestas, Object.fromEntries(Object.entries((await db.get("resp:" + u, { type: "json" })) || {}).map(([k, v]) => [k, { ...v, usuario: u }])));
    return J({ usuarios: Object.fromEntries(Object.entries(us).map(([k, v]) => [k, { nombre: v.nombre }])), lineas, respuestas });
  }
  if (ruta === "admin/usuario") {
    const id = String(body.id || "").trim().toLowerCase();
    if (!/^[a-z0-9_]{2,20}$/.test(id) || id === "admin") return E("ID inválido (2-20 letras/números, sin espacios).");
    if (body.borrar) { delete us[id]; } else {
      if (!us[id] && !body.password) return E("Un usuario nuevo necesita contraseña.");
      us[id] = { nombre: body.nombre || id, hash: body.password ? hash(body.password) : us[id].hash };
    }
    await db.setJSON("usuarios", us);
    return J({ ok: true });
  }
  if (ruta === "admin/linea") {
    const l = body.linea || {};
    if (!l.id) return E("Falta el número de línea.");
    const i = lineas.findIndex((x) => x.id === l.id);
    if (body.borrar) { if (i >= 0) lineas.splice(i, 1); }
    else if (i >= 0) lineas[i] = { ...lineas[i], ...l };
    else lineas.push({ eje: "", obj: "", est: "", texto: "", unidad: "", area: "sinasignar", ...l });
    await db.setJSON("lineas", lineas);
    return J({ ok: true });
  }
  return E("Ruta no encontrada.", 404);
};

export const config = { path: "/api/*" };
