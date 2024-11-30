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

    window.toggleTagSelect = function () {
        const modal = document.getElementById('tag-modal');
        modal.style.display = "flex";
        loadUserTags();
    };

    window.loadUserTags = function () {
        const csrfToken = document.querySelector('input[name="_csrf"]').value;

        fetch('/tasks/tags/user', {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            }
        })
            .then(response => response.json())
            .then(tags => {
                const select = document.getElementById('user-tags-select');
                select.innerHTML = '<option value="" disabled selected>Выберите тег</option>';
                tags.forEach(tag => {
                    const option = document.createElement('option');
                    option.value = tag.id;
                    option.textContent = tag.tag;
                    select.appendChild(option);
                });
            })
            .catch(() => {
                showErrorNotification('Ошибка при загрузке тегов');
            });
    };

    window.applySelectedTag = function (tagId) {
        const select = document.getElementById('user-tags-select');
        const selectedTag = document.querySelector(`#user-tags-select option[value="${tagId}"]`);

        if (selectedTag) {
            const tagTextElement = document.getElementById('tag-text');
            tagTextElement.textContent = selectedTag.textContent;

            const csrfToken = document.querySelector('input[name="_csrf"]').value;
            const taskId = document.getElementById('task-id').value;

            fetch('/tasks/tag/update', {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-TOKEN": csrfToken
                },
                body: JSON.stringify({
                    tagId: tagId,
                    taskId: taskId
                })
            })
                .then(response => {
                    if (response.ok) {
                        showSuccessNotification('Тег успешно обновлён');
                        closeTagModal('select');
                    } else {
                        showErrorNotification('Ошибка при обновлении тега');
                    }
                })
                .catch(() => {
                    showErrorNotification('Ошибка соединения с сервером');
                });
        }
    };

    window.openTagModal = function () {
        const tagSelectModal = document.getElementById('tag-modal');
        tagSelectModal.style.display = "none";

        const modal = document.getElementById('tag-modal-create');
        modal.style.display = "flex";

        document.getElementById('tag-input').value = '';
    };

    window.closeTagModal = function (modalType) {
        if (modalType === 'create') {
            const modal = document.getElementById('tag-modal-create');
            modal.style.display = "none";
        } else {
            const modal = document.getElementById('tag-modal');
            modal.style.display = "none";
        }
    };

    window.saveTag = function () {
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
                    closeTagModal('create');
                    showSuccessNotification('Тег успешно сохранен');
                } else {
                    showErrorNotification('Ошибка при сохранении тега');
                }
            })
            .catch(() => {
                showErrorNotification('Ошибка соединения с сервером');
            });
    };

    window.addEventListener("click", function (event) {
        const modal = document.getElementById('tag-modal');
        if (event.target === modal) {
            closeTagModal('select');
        }

        const createModal = document.getElementById('tag-modal-create');
        if (event.target === createModal) {
            closeTagModal('create');
        }
    });

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

    const closeButtons = document.querySelectorAll('.tag-close-button');
    closeButtons.forEach(button => {
        button.addEventListener("click", function () {
            const modal = button.closest('.modal');
            const modalType = modal.id === 'tag-modal' ? 'select' : 'create';
            closeTagModal(modalType);
        });
    });
});

document.addEventListener("DOMContentLoaded", function () {
    const taskId = document.getElementById('task-id').value;
    loadTaskTag(taskId);

    function loadTaskTag(taskId) {
        const csrfToken = document.querySelector('input[name="_csrf"]').value;

        fetch(`/tasks/${taskId}/tag`, {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            }
        })
            .then(response => response.json())
            .then(tag => {
                if (tag) {
                    const tagTextElement = document.getElementById('tag-text');
                    tagTextElement.textContent = tag.tag;
                }
            })
            .catch(() => {
                showErrorNotification('Ошибка при загрузке тега');
            });
    }
});