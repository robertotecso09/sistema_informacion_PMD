/* Panel de Operaciones TECSO — service worker mínimo (piloto)
   Cachea la cáscara de la página para abrir rápido; los datos siempre
   van en vivo a Supabase. Permite mostrar notificaciones del sistema. */
const CACHE = 'tecso-op-v6';
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(['./', './index.html', './icon.svg'])).then(() => self.skipWaiting()));
});
self.addEventListener('activate', e => { e.waitUntil(self.clients.claim()); });
self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);
  if (url.hostname.endsWith('supabase.co')) return; // datos siempre en vivo
  e.respondWith(
    fetch(e.request).then(r => {
      const copia = r.clone();
      caches.open(CACHE).then(c => c.put(e.request, copia));
      return r;
    }).catch(() => caches.match(e.request))
  );
});
self.addEventListener('notificationclick', e => {
  e.notification.close();
  e.waitUntil(clients.matchAll({ type: 'window' }).then(ws => {
    if (ws.length) return ws[0].focus();
    return clients.openWindow('./');
  }));
});
