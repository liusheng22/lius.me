(function () {
  function onReady(fn) {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", fn);
    } else {
      fn();
    }
  }

  onReady(function () {
    var imgs = document.querySelectorAll(".post-content img");
    if (!imgs.length) return;

    var overlay = document.createElement("div");
    overlay.className = "zoom-overlay";
    overlay.setAttribute("role", "dialog");
    overlay.setAttribute("aria-modal", "true");
    overlay.setAttribute("aria-label", "Image preview");
    overlay.innerHTML =
      '<button type="button" class="zoom-overlay__close" aria-label="Close image preview">Close</button>' +
      '<img class="zoom-overlay__img" alt="">';

    var closeBtn = overlay.querySelector(".zoom-overlay__close");
    var overlayImg = overlay.querySelector(".zoom-overlay__img");

    var prevOverflow = "";
    var active = null;

    function openZoom(imgEl) {
      active = imgEl;
      var src = imgEl.currentSrc || imgEl.src;
      if (!src) return;

      overlayImg.src = src;
      overlayImg.alt = imgEl.alt || "";
      overlay.classList.add("is-open");

      prevOverflow = document.documentElement.style.overflow || "";
      document.documentElement.style.overflow = "hidden";
    }

    function closeZoom() {
      overlay.classList.remove("is-open");
      overlayImg.src = "";
      document.documentElement.style.overflow = prevOverflow;
      active = null;
    }

    document.body.appendChild(overlay);

    closeBtn.addEventListener("click", closeZoom);
    overlay.addEventListener("click", function (e) {
      if (e.target === overlay) closeZoom();
    });

    document.addEventListener("keydown", function (e) {
      if (!overlay.classList.contains("is-open")) return;
      if (e.key === "Escape") closeZoom();
    });

    imgs.forEach(function (img) {
      if (img.classList.contains("no-zoom")) return;
      if (img.getAttribute("data-no-zoom") === "true") return;
      // If the author already wrapped the image in a link, don't hijack it.
      if (img.closest("a")) return;

      img.classList.add("zoomable");
      img.addEventListener("click", function () {
        openZoom(img);
      });

      img.setAttribute("tabindex", "0");
      img.addEventListener("keydown", function (e) {
        if (e.key === "Enter") openZoom(img);
      });
    });
  });
})();

