document.addEventListener("turbo:load", function() {
  // ハンバーガーメニュー（レスポンシブナビゲーション用）
  let hamburger = document.querySelector("#hamburger");
  if (hamburger) {
    hamburger.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector("#navbar-menu");
      menu.classList.toggle("collapse");
    });
  }

  // アカウントドロップダウンメニュー
  let account = document.querySelector("#account");
  if (account) {
    account.addEventListener("click", function(event) {
      event.preventDefault();
      let menu = document.querySelector("#dropdown-menu");
      menu.classList.toggle("active");
    });
  }

  // ドロップダウンメニュー外をクリックしたときに閉じる
  document.addEventListener("click", function(event) {
    let dropdownMenu = document.querySelector("#dropdown-menu");
    let account = document.querySelector("#account");
    if (dropdownMenu && !dropdownMenu.contains(event.target) && !account.contains(event.target)) {
      dropdownMenu.classList.remove("active");
    }
  });

  // オフキャンバスメニューのトグル
  let offcanvasToggle = document.querySelector("#offcanvas-toggle");
  let offcanvasMenu = document.querySelector("#offcanvas-menu");
  let offcanvasClose = document.querySelector("#offcanvas-close");

  if (offcanvasToggle) {
    offcanvasToggle.addEventListener("click", function(event) {
      event.preventDefault();
      offcanvasMenu.classList.add("active");
    });
  }

  if (offcanvasClose) {
    offcanvasClose.addEventListener("click", function(event) {
      event.preventDefault();
      offcanvasMenu.classList.remove("active");
    });
  }

  // オフキャンバスメニュー外をクリックしたときに閉じる
  document.addEventListener("click", function(event) {
    if (offcanvasMenu && offcanvasMenu.classList.contains("active") &&
        !offcanvasMenu.contains(event.target) &&
        event.target !== offcanvasToggle) {
      offcanvasMenu.classList.remove("active");
    }
  });
});
