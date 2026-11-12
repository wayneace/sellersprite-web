(() => {
  const text = (el) => (el && (el.innerText || el.textContent) || "").replace(/\s+/g, " ").trim();
  const visible = (el) => {
    if (!el) return false;
    const r = el.getBoundingClientRect();
    return r.width > 0 && r.height > 0;
  };
  let serializationErrors = 0;
  const plain = (value) => {
    try { return JSON.parse(JSON.stringify(value)); } catch (e) {
      serializationErrors += 1;
      try {
        const shallow = {};
        for (const key of Object.keys(value)) {
          const v = value[key];
          shallow[key] = (v === null || typeof v === "string" || typeof v === "number" || typeof v === "boolean") ? v : null;
        }
        return shallow;
      } catch (e2) { return null; }
    }
  };
  const vms = [];
  for (const el of document.querySelectorAll("*")) {
    if (el.__vue__ && !vms.includes(el.__vue__)) vms.push(el.__vue__);
  }
  const tables = [...document.querySelectorAll(".el-table")];
  const table = tables.find((t) => t.__vue__) || tables[0] || null;
  let vm = table && table.__vue__;
  while (vm && !(vm.store && vm.store.states)) vm = vm.$parent;
  const store = vm && vm.store;
  let items = null;
  let source = "none";
  if (store && store.states && Array.isArray(store.states.data)) {
    items = store.states.data;
    source = "el-table-store";
  }
  if (!items) {
    let best = null;
    for (const candidate of vms) {
      for (const src of ["$data", "$props"]) {
        const arr = candidate[src] && candidate[src].tableData;
        if (Array.isArray(arr) && (!best || arr.length > best.length)) best = arr;
      }
    }
    if (best) { items = best; source = "vue-tableData"; }
  }
  if (!items) items = [];
  const headers = table
    ? [...table.querySelectorAll("thead th")].map(text).filter(Boolean)
    : [];
  const pag = document.querySelector(".el-pagination");
  const pvm = pag && pag.__vue__;
  const mask = [...document.querySelectorAll(".el-table .el-loading-mask")].find(visible);
  const emptyEl = [...document.querySelectorAll(".el-table__empty-text")].find(visible);
  return {
    ok: true,
    url: location.href,
    title: document.title,
    headers,
    items: items.map((row) => plain(row) || {}),
    rowCount: items.length,
    total: pvm && typeof pvm.total === "number" ? pvm.total : null,
    pageSize: pvm ? pvm.pageSize : null,
    currentPage: pvm ? pvm.currentPage : null,
    loading: !!mask,
    empty: !!emptyEl || (items.length === 0 && /暂无数据|没有找到|无数据|未找到/i.test(text(document.body).slice(0, 2000))),
    source,
    serializationErrors
  };
})()
