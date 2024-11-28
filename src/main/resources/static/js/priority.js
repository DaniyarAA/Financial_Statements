document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("priorityModal");
    const closeButton = modal.querySelector(".priority-close-button");
    const priorityList = modal.querySelector(".priority-list");
    const csrfToken = document.querySelector('input[name="_csrf"]').value;

    document.querySelectorAll(".task-priority-bar").forEach(function (priorityBar) {
        priorityBar.addEventListener("click", function (event) {
            const taskId = priorityBar.dataset.taskId;
            modal.style.display = "block";
            priorityList.dataset.taskId = taskId;
        });
    });

    closeButton.addEventListener("click", function () {
        modal.style.display = "none";
    });

    window.addEventListener("click", function (event) {
        if (event.target === modal) {
            modal.style.display = "none";
        }
    });

    const priorities = [
        { id: 1, name: 'Незначительная', initial: 'Н', class: 'low' },
        { id: 2, name: 'Обычная', initial: 'О', class: 'normal' },
        { id: 3, name: 'Серьезная', initial: 'С', class: 'serious' },
        { id: 4, name: 'Неотложная', initial: 'Н', class: 'urgent' },
        { id: 5, name: 'Критическая', initial: 'К', class: 'critical' }
    ];

    priorityList.innerHTML = '';
    priorities.forEach(priority => {
        const listItem = document.createElement('li');
        listItem.classList.add('priority-item');
        listItem.dataset.priorityId = priority.id;

        const badge = document.createElement('span');
        badge.classList.add('priority-badge', priority.class);
        badge.textContent = priority.initial;

        const name = document.createElement('span');
        name.classList.add('priority-name');
        name.textContent = priority.name;

        listItem.appendChild(badge);
        listItem.appendChild(name);
        priorityList.appendChild(listItem);
    });

    priorityList.addEventListener("click", function (event) {
        const clickedItem = event.target.closest(".priority-item");
        if (clickedItem) {
            const taskId = priorityList.dataset.taskId;
            const priorityId = clickedItem.dataset.priorityId;
            const priorityName = clickedItem.querySelector(".priority-name").textContent;
            const priorityClass = clickedItem.querySelector(".priority-badge").classList[1];
            const priorityBar = document.querySelector(".task-priority-bar[data-task-id='" + taskId + "']");

            updatePriorityForTask(taskId, priorityClass, priorityBar);

            fetch(`/tasks/${taskId}/priority`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded",
                    "X-CSRF-TOKEN": csrfToken
                },
                body: new URLSearchParams({ priorityId, priorityColor: getPriorityColor(priorityClass) })
            })
                .then(response => {
                    if (response.ok) {
                        showSuccessNotification(`Приоритет задачи обновлен`);
                        modal.style.display = "none";
                    } else {
                        showErrorNotification("Ошибка при обновлении приоритета");
                    }
                })
                .catch(error => {
                    console.error("Ошибка при отправке запроса:", error);
                    showErrorNotification("Произошла ошибка при обновлении приоритета");
                });
        }
    });

    function getPriorityColor(priorityClass) {
        switch (priorityClass) {
            case 'low':
                return '#5b5b5b';
            case 'normal':
                return '#90ee90';
            case 'serious':
                return '#ffcc00';
            case 'urgent':
                return '#ff4d4d';
            case 'critical':
                return '#ff80ff';
            default:
                return '#EBE30E';
        }
    }

    function updatePriorityForTask(taskId, priorityClass, priorityBar) {
        priorityBar.classList.remove("low", "normal", "serious", "urgent", "critical");
        priorityBar.classList.add(priorityClass);
        const priorityColor = getPriorityColor(priorityClass);
        priorityBar.style.backgroundColor = priorityColor;

        const arrowContainer = document.querySelector(".task-priority-arrows[data-task-id='" + taskId + "']");
        const arrowCount = getArrowCount(priorityClass);

        arrowContainer.innerHTML = '';

        for (let i = 1; i <= arrowCount; i++) {
            const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
            svg.setAttribute("xmlns", "http://www.w3.org/2000/svg");
            svg.setAttribute("width", "18");
            svg.setAttribute("height", "18");
            svg.setAttribute("fill", "currentColor");
            svg.setAttribute("class", "bi bi-caret-up");
            svg.setAttribute("viewBox", "0 0 16 16");
            const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
            path.setAttribute("d", "M3.204 11h9.592L8 5.519zm-.753-.659 4.796-5.48a1 1 0 0 1 1.506 0l4.796 5.48c.566.647.106 1.659-.753 1.659H3.204a1 1 0 0 1-.753-1.659");
            svg.appendChild(path);
            arrowContainer.appendChild(svg);
        }
    }

    function getArrowCount(priorityClass) {
        switch (priorityClass) {
            case 'low':
                return 1;
            case 'normal':
                return 2;
            case 'serious':
                return 3;
            case 'urgent':
                return 4;
            case 'critical':
                return 5;
            default:
                return 0;
        }
    }

    function showSuccessNotification(message) {
        const notification = document.createElement("div");
        notification.classList.add("priority-notification", "success");
        notification.innerHTML = `${message}`;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.classList.add("show");
        }, 100);

        setTimeout(() => {
            notification.classList.remove("show");
            setTimeout(() => {
                notification.remove();
            }, 300);
        }, 3000);
    }

    function showErrorNotification(message) {
        const notification = document.createElement("div");
        notification.classList.add("priority-notification", "error");
        notification.innerHTML = `${message}`;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.classList.add("show");
        }, 100);

        setTimeout(() => {
            notification.classList.remove("show");
            setTimeout(() => {
                notification.remove();
            }, 300);
        }, 3000);
    }
});