document.addEventListener("DOMContentLoaded", function () {
    const taskTags = document.querySelectorAll('.task-tag');

    taskTags.forEach(tagTextElement => {
        const shortText = tagTextElement.querySelector('.tag-text-short');
        const fullText = tagTextElement.querySelector('.tag-text-full');
        const tooltip = tagTextElement.querySelector('.tooltip');

        const tagText = shortText.textContent;

        if (tagText.length > 3) {
            shortText.textContent = tagText.substring(0, 3);
            fullText.textContent = tagText;
        } else {
            shortText.textContent = tagText;
            fullText.style.display = 'none';
        }

        tagTextElement.addEventListener('mouseenter', function() {
            tooltip.style.display = 'block';
        });

        tagTextElement.addEventListener('mouseleave', function() {
            tooltip.style.display = 'none';
        });
    });

    window.toggleTagSelect = function (taskId) {
        const modal = document.getElementById(`tag-modal-${taskId}`);
        modal.style.display = "flex";
        loadUserTags(taskId);
    };

    window.loadUserTags = function (taskId) {
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
                const select = document.getElementById(`user-tags-select-${taskId}`);
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

    window.applySelectedTag = function (taskId, tagId) {
        const selectedTag = document.querySelector(`#user-tags-select-${taskId} option[value="${tagId}"]`);

        if (selectedTag) {
            const tagText = selectedTag.textContent;

            updateTagTextAndTooltip(taskId, tagText);

            const csrfToken = document.querySelector('input[name="_csrf"]').value;

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
                        closeTagModal('select', taskId);
                    } else {
                        showErrorNotification('Ошибка при обновлении тега');
                    }
                })
                .catch(() => {
                    showErrorNotification('Ошибка соединения с сервером');
                });
        }
    };

    window.openTagModal = function (taskId) {
        const tagSelectModal = document.getElementById(`tag-modal-${taskId}`);
        tagSelectModal.style.display = "none";

        const modal = document.getElementById(`tag-modal-create-${taskId}`);
        modal.style.display = "flex";

        document.getElementById(`tag-input-${taskId}`).value = '';
        document.getElementById(`tag-error-${taskId}`).textContent = '';
    };

    window.closeTagModal = function (modalType, taskId) {
        const modal = document.getElementById(
            modalType === "create"
                ? `tag-modal-create-${taskId}`
                : `tag-modal-${taskId}`
        );
        if (modal) {
            modal.style.display = "none";
        }
    };

    window.saveTag = function (taskId) {
        const tagInput = document.getElementById(`tag-input-${taskId}`).value;
        const errorContainer = document.getElementById(`tag-error-${taskId}`);
        const csrfToken = document.querySelector('input[name="_csrf"]').value;

        errorContainer.textContent = '';

        if (tagInput.trim() === '') {
            errorContainer.textContent = 'Тег не может быть пустым';
            return;
        }

        fetch('/tasks/tags/count', {
            method: 'GET',
            headers: {
                "X-CSRF-TOKEN": csrfToken
            }
        })
            .then(response => response.json())
            .then(tagCount => {
                if (tagCount >= 10) {
                    errorContainer.textContent = 'Лимит на теги достигнут';
                    return;
                }

                fetch(`/tasks/tags/unique?tag=${tagInput}`, {
                    method: 'GET',
                    headers: {
                        "X-CSRF-TOKEN": csrfToken
                    }
                })
                    .then(response => {
                        if (!response.ok) {
                            errorContainer.textContent = 'Тег с таким названием уже есть';
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
                                    showSuccessNotification('Тег успешно создан');
                                    updateTagTextAndTooltip(taskId, tagInput);
                                    closeTagModal('create', taskId);
                                } else {
                                    errorContainer.textContent = 'Ошибка при сохранении тега';
                                }
                            })
                            .catch(() => {
                                errorContainer.textContent = 'Ошибка соединения с сервером';
                            });
                    })
                    .catch(() => {
                        errorContainer.textContent = 'Ошибка при проверке уникальности тега';
                    });
            })
            .catch(() => {
                errorContainer.textContent = 'Ошибка при проверке количества тегов';
            });
    };


    window.addEventListener("click", function (event) {
        const modals = document.querySelectorAll(".tag-select-modal");
        modals.forEach((modal) => {
            if (event.target === modal) {
                modal.style.display = "none";
            }
        });
    });

    function updateTagTextAndTooltip(taskId, tagText) {
        const tagTextElement = document.getElementById(`tag-text-${taskId}`);
        if (!tagTextElement) {
            console.error(`Элемент с ID tag-text-${taskId} не найден.`);
            return;
        }

        const shortText = tagTextElement.querySelector('.tag-text-short');
        const fullText = tagTextElement.querySelector('.tag-text-full');
        let tooltip = document.getElementById(`tooltip-${taskId}`);

        if (tagText.length > 3) {
            if (shortText) shortText.textContent = `${tagText.substring(0, 3)}...`;
            if (fullText) {
                fullText.textContent = tagText;
                fullText.style.display = 'none';
            }
        } else {
            if (shortText) shortText.textContent = tagText;
            if (fullText) fullText.style.display = 'none';
        }

        if (tooltip) {
            tooltip.textContent = tagText;
        } else {
            tooltip = document.createElement('div');
            tooltip.id = `tooltip-${taskId}`;
            tooltip.className = 'tooltip';
            tooltip.textContent = tagText;
            tagTextElement.parentNode.appendChild(tooltip);
        }

        tagTextElement.setAttribute('data-tooltip', tagText);

        const showTooltip = () => {
            tooltip.style.visibility = 'visible';
            tooltip.style.opacity = '1';
        };

        const hideTooltip = () => {
            tooltip.style.visibility = 'hidden';
            tooltip.style.opacity = '0';
        };

        tagTextElement.addEventListener('mouseover', showTooltip);
        tagTextElement.addEventListener('mouseout', (e) => {
            if (!tooltip.contains(e.relatedTarget)) {
                hideTooltip();
            }
        });

        tooltip.addEventListener('mouseover', showTooltip);
        tooltip.addEventListener('mouseout', (e) => {
            if (!tagTextElement.contains(e.relatedTarget)) {
                hideTooltip();
            }
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

    const closeButtons = document.querySelectorAll('.tag-close-button');
    closeButtons.forEach(button => {
        button.addEventListener("click", function () {
            const modal = button.closest('.modal');
            const modalType = modal.id === 'tag-modal' ? 'select' : 'create';
            closeTagModal(modalType);
        });
    });

    taskTags.forEach(tagTextElement => {
        const taskId = tagTextElement.dataset.taskId;
        loadTaskTag(taskId);
    });

    function loadTaskTag(taskId) {
        const csrfToken = document.querySelector('input[name="_csrf"]').value;

        fetch(`/tasks/${taskId}/tag`, {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": csrfToken
            }
        })
            .then(response => {
                if (!response.ok) {
                    if (response.status === 404) {
                        console.log(`Тег для задачи ${taskId} не найден.`);
                        return null;
                    }
                    throw new Error(`Ошибка HTTP: ${response.status}`);
                }
                return response.json();
            })
            .then(tag => {
                if (tag && tag.tag) {
                    const tagTextElement = document.getElementById(`tag-text-${taskId}`);
                    const shortText = tagTextElement.querySelector('.tag-text-short');
                    const fullText = tagTextElement.querySelector('.tag-text-full');
                    const tooltip = tagTextElement.querySelector('.tooltip');

                    const tagText = tag.tag;

                    if (tagText.length > 3) {
                        shortText.textContent = tagText.substring(0, 3) + '...';
                        fullText.textContent = tagText;
                    } else {
                        shortText.textContent = tagText;
                        fullText.style.display = 'none';
                    }

                    if (tooltip) {
                        tooltip.textContent = tagText;
                    }
                } else {
                    console.log(`Для задачи ${taskId} тег отсутствует.`);
                }
            })
            .catch(error => {
                console.error(error);
                showErrorNotification('Ошибка при загрузке тега');
            });
    }
});