document.addEventListener('turbo:load', () => {
  function previewImage(inputId, previewId, removeBtnId) {
    const input = document.getElementById(inputId);
    const preview = document.getElementById(previewId);
    const removeBtn = document.getElementById(removeBtnId);

    if (input && preview) {
      input.addEventListener('change', (event) => {
        const file = event.target.files[0];
        if (file) {
          const reader = new FileReader();
          reader.onload = (e) => {
            let img = preview.querySelector('img');
            if (!img) {
              img = document.createElement('img');
              preview.appendChild(img);
            }
            img.src = e.target.result;
            removeBtn.style.display = 'block';
          };
          reader.readAsDataURL(file);
        }
      });
    }
  }

  previewImage('thumbnail-input', 'thumbnail-preview');
  previewImage('image1-input', 'image1-preview');
  previewImage('image2-input', 'image2-preview');  

  // 「＋」ボタンでファイル選択をトリガーする
  const addImageButtons = document.querySelectorAll('.btn-add-image');
  addImageButtons.forEach((button) => {
    button.addEventListener('click', () => {
      const inputId = button.getAttribute('data-input-id');
      const input = document.getElementById(inputId);
      if (input) {
        input.click();
      }
    });
  });
});
