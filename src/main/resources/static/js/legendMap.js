function openModal() {
    const modal = document.getElementById('legendMapModal');
    modal.style.display = 'flex';
    setTimeout(() => modal.classList.add('show'), 10);

    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeModal();
        }
    });
}

function closeModal() {
    const modal = document.getElementById('legendMapModal');
    modal.classList.remove('show');
    setTimeout(() => modal.style.display = 'none', 300);
}