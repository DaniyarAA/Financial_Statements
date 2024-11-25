document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("priorityModal");
    const closeButton = modal.querySelector(".priority-close-button");

    document.querySelector(".task-list").addEventListener("click", function (event) {
        if (event.target.closest(".task-priority-bar")) {
            modal.style.display = "block";
        }
    });

    closeButton.addEventListener("click", function () {
        modal.style.display = "none";
    });

    window.addEventListener("click", function (event) {
        if (event.target === modal) {
            modal.style.display = "none";
        }
    });

    const priorityList = modal.querySelector(".priority-list");
    const priorities = [
        {name: 'Незначительная', initial: 'н'},
        {name: 'Неотложная', initial: 'н'},
        {name: 'Критическая', initial: 'к'},
        {name: 'Серьезная', initial: 'с'},
        {name: 'Обычная', initial: 'о'}
    ];

    priorityList.innerHTML = '';

    priorities.forEach(priority => {
        const listItem = document.createElement('li');
        listItem.classList.add('priority-item');

        const badge = document.createElement('span');
        badge.classList.add('priority-badge');

        if (priority.name === 'Незначительная') {
            badge.classList.add('low');
        } else if (priority.name === 'Неотложная') {
            badge.classList.add('urgent');
        } else if (priority.name === 'Критическая') {
            badge.classList.add('critical');
        } else if (priority.name === 'Серьезная') {
            badge.classList.add('serious');
        } else if (priority.name === 'Обычная') {
            badge.classList.add('normal');
        }

        badge.textContent = priority.initial.toUpperCase();
        const name = document.createElement('span');
        name.classList.add('priority-name');
        name.textContent = priority.name;

        listItem.appendChild(badge);
        listItem.appendChild(name);
        priorityList.appendChild(listItem);
    });
});