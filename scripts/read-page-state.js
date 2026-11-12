(() => {
  const text = (el) => (el && (el.innerText || el.textContent) || "").replace(/\s+/g, " ").trim();
  const visible = (el) => {
    if (!el) return false;
    const r = el.getBoundingClientRect();
    return r.width > 0 && r.height > 0;
  };
  const messages = [...document.querySelectorAll(
    ".el-message, .el-notification, .el-dialog__wrapper, .el-message-box__wrapper"
  )].filter(visible).map(text).filter(Boolean).slice(0, 10);
  const mask = [...document.querySelectorAll(".el-loading-mask")].find(visible);
  const emptyEl = [...document.querySelectorAll(".el-table__empty-text")].find(visible);
  const pag = document.querySelector(".el-pagination");
  const pvm = pag && pag.__vue__;
  return {
    ok: true,
    url: location.href,
    title: document.title,
    bodyText: text(document.body).slice(0, 2000),
    messages,
    loading: !!mask,
    emptyText: emptyEl ? text(emptyEl) : "",
    total: pvm && typeof pvm.total === "number" ? pvm.total : null,
    currentPage: pvm ? pvm.currentPage : null
  };
})()
