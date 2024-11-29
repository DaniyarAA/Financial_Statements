document.addEventListener("DOMContentLoaded", function () {
    const taskTags = document.querySelectorAll('.task-tag');

    taskTags.forEach(tagTextElement => {
        const shortText = tagTextElement.querySelector('.tag-text-short');
        const fullText = tagTextElement.querySelector('.tag-text-full');

        tagTextElement.addEventListener('mouseenter', function() {
            fullText.style.display = 'inline';
            shortText.style.display = 'none';
        });

        tagTextElement.addEventListener('mouseleave', function() {
            fullText.style.display = 'none';
            shortText.style.display = 'inline';
        });
    });
});

function openTagModal() {
    const modal = document.getElementById('tag-modal');
    modal.classList.add('show');
    modal.style.display = "flex";

    document.getElementById('tag-input').value = '';
}

const closeButton = document.querySelector('.tag-close-button');
closeButton.addEventListener("click", function () {
    closeTagModal();
});

window.addEventListener("click", function (event) {
    const modal = document.getElementById('tag-modal');
    if (event.target === modal) {
        closeTagModal();
    }
});

function closeTagModal() {
    const modal = document.getElementById('tag-modal');
    modal.classList.remove('show');
    modal.style.display = "none";
}

function saveTag() {
    const tagInput = document.getElementById('tag-input').value;
    const csrfToken = document.querySelector('input[name="_csrf"]').value;
    const taskId = document.getElementById('task-id').value;

    if (tagInput.trim() === '') {
        showErrorNotification('Введите текст для тега!');
        return;
    }

    fetch('/tasks/tag', {
        method: 'POST',
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": csrfToken
        },
        body: JSON.stringify({
            tag: tagInput,
            taskId: taskId
        })
    })
        .then(response => {
            if (response.ok) {
                document.getElementById('tag-text').innerText = tagInput;
                closeTagModal();
                showSuccessNotification('Тег успешно сохранен');
            } else {
                showErrorNotification('Ошибка при сохранении тега');
            }
        })
        .catch(() => {
            showErrorNotification('Ошибка соединения с сервером');
        });
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