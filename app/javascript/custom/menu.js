document.addEventListener("turbo:load", function() {
  // オフキャンバスメニューのトグル
  const offcanvasToggle = document.querySelector("#offcanvas-toggle");
  const offcanvasMenu = document.querySelector("#offcanvas-menu");
  const offcanvasClose = document.querySelector("#offcanvas-close");
  
  if (offcanvasToggle) {
    offcanvasToggle.addEventListener("click", function(event) {
      event.preventDefault();
      offcanvasMenu.classList.toggle("active");
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
    if (offcanvasMenu && offcanvasMenu.classList.contains("active") && !offcanvasMenu.contains(event.target) && event.target !== offcanvasToggle) {
      offcanvasMenu.classList.remove("active");
    }
  });

  // ドロップダウンメニューのトグル（アカウント・通知）
  const toggleDropdown = (triggerSelector, menuSelector) => {
    const trigger = document.querySelector(triggerSelector);
    const menu = document.querySelector(menuSelector);

    if (trigger) {
      trigger.addEventListener("click", function(event) {
        event.preventDefault();
        menu.classList.toggle("active");
      });
    }

    // ドロップダウンメニュー外をクリックしたときに閉じる
    document.addEventListener("click", function(event) {
      if (menu && !menu.contains(event.target) && !trigger.contains(event.target)) {
        menu.classList.remove("active");
      }
    });
  };

  // アカウントと通知のドロップダウンに適用
  toggleDropdown("#account", "#dropdown-menu");
  toggleDropdown("#notification-toggle", "#notification-dropdown");
});
