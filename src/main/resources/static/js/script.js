function switchToTileView() {
    document.getElementById('tileView').classList.remove('hidden');
    document.getElementById('listView').classList.add('hidden');
    localStorage.setItem('viewMode', 'tile');
}

function switchToListView() {
    document.getElementById('listView').classList.remove('hidden');
    document.getElementById('tileView').classList.add('hidden');
    localStorage.setItem('viewMode', 'list');
}

document.addEventListener("DOMContentLoaded", function() {
    const savedViewMode = localStorage.getItem('viewMode');
    if (savedViewMode === 'tile') {
        switchToTileView();
    } else {
        switchToListView();
    }
});

document.getElementById('roleId').addEventListener('change', function () {
    if (this.value === 'create_new_role') {
        const modal = new bootstrap.Modal(document.getElementById('createRoleModal'));
        modal.show();
    }
});

function deleteUser(userId) {
    if (confirm('Вы уверены, что хотите удалить этого пользователя?')) {
        fetch('/admin/user/delete/' + userId, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('input[name="csrf"]').value
            }
        })
            .then(response => {
                if (response.ok) {
                    alert('Пользователь успешно удалён.');
                    window.location.href = '/admin/users';
                } else {
                    alert('Ошибка при удалении пользователя.');
                }
            })
            .catch(error => {
                console.error('Ошибка:', error);
                alert('Ошибка при удалении пользователя.');
            });
    }
}

function openEditRoleModal(roleId) {
    document.getElementById("editRoleId").value = roleId;
    const authoritiesContainer = document.getElementById("editAuthoritiesContainer");
    authoritiesContainer.innerHTML = "";

    fetch('/admin/roles/edit/' + roleId)
        .then(response => response.json())
        .then(roleDto => {
            document.getElementById("editRoleName").value = roleDto.roleName;

            fetch('/admin/authorities')
                .then(response => response.json())
                .then(allAuthorities => {
                    allAuthorities.forEach(authority => {
                        const checkbox = document.createElement("input");
                        checkbox.type = "checkbox";
                        checkbox.id = 'edit_auth_' + authority.id;
                        checkbox.name = "authorityIds";
                        checkbox.value = authority.id;
                        checkbox.checked = roleDto.authorities.some(auth => auth.id === authority.id);
                        checkbox.classList.add("form-check-input");

                        const label = document.createElement("label");
                        label.htmlFor = checkbox.id;
                        label.classList.add("form-check-label");
                        label.innerText = authority.authorityName;

                        const div = document.createElement("div");
                        div.classList.add("form-check");
                        div.appendChild(checkbox);
                        div.appendChild(label);

                        authoritiesContainer.appendChild(div);
                    });

                    document.getElementById("editRoleModal").style.display = "block";
                })
                .catch(error => console.error("Ошибка при получении всех привилегий:", error));
        })
        .catch(error => console.error("Ошибка при получении данных роли:", error));
}

function openCreateRoleModal() {
    document.getElementById("createRoleName").value = "";
    document.querySelectorAll('#createRoleModal input[name="authorityIds"]').forEach(input => input.checked = false);
    showModal('createRoleModal');
}

function createRole() {
    const roleName = document.getElementById("createRoleName").value;
    const authorityIds = Array.from(document.querySelectorAll('#createRoleModal input[name="authorityIds"]:checked')).map(input => input.value);
    const roleNameErrorElement = document.querySelector('#createRoleModal #roleNameError');
    const authorityErrorElement = document.querySelector('#createRoleModal #authorityError');
    roleNameErrorElement.innerText = "";
    authorityErrorElement.innerText = "";

    fetch('/admin/roles/checkRoleName?name=' + encodeURIComponent(roleName))
        .then(response => response.json())
        .then(isNameTaken => {
            let hasError = false;

            if (isNameTaken) {
                roleNameErrorElement.innerText = "Роль с таким именем уже существует.";
                hasError = true;
            }

            if (authorityIds.length === 0) {
                authorityErrorElement.innerText = "Выберите хотя бы одну привилегию для роли.";
                hasError = true;
            }
            if (roleName === "") {
                roleNameErrorElement.innerText = "Название роли не должно быть пустым.";
                hasError = true;
            }

            if (hasError) return;

            fetch('/admin/roles/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': document.getElementById("csrfToken").value
                },
                body: JSON.stringify({ roleName, authorityIds })
            }).then(response => {
                if (response.ok) location.reload();
            });
        });
}

function saveRole() {
    const roleName = document.getElementById("editRoleName").value.trim();
    const checkboxes = document.querySelectorAll("#editAuthoritiesContainer input[type='checkbox']");
    const selectedAuthorities = Array.from(checkboxes).filter(checkbox => checkbox.checked).map(checkbox => checkbox.value);

    document.getElementById("roleNameError").textContent = "";
    document.getElementById("authorityError").textContent = "";

    let hasErrors = false;

    if (!roleName) {
        document.getElementById("roleNameError").textContent = "Название роли не может быть пустым.";
        hasErrors = true;
    }

    if (selectedAuthorities.length === 0) {
        document.getElementById("authorityError").textContent = "Роль должна иметь хотя бы одну привилегию.";
        hasErrors = true;
    }

    if (hasErrors) {
        return;
    }

    const roleId = document.getElementById("editRoleId").value;
    const csrfToken = document.getElementById("csrfToken").value;

    fetch('/admin/roles/edit/' + roleId, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": csrfToken
        },
        body: JSON.stringify({
            id: roleId,
            roleName,
            authorities: selectedAuthorities.map(id => ({ id: parseInt(id) }))
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                if (data.error === "duplicate") {
                    document.getElementById("roleNameError").textContent = "Роль с таким именем уже существует.";
                } else {
                    document.getElementById("authorityError").textContent = data.message || "Произошла ошибка при сохранении.";
                }
            } else {
                closeModal("editRoleModal");
                location.reload();
            }
        })
        .catch(error => {
            console.error("Ошибка при сохранении:", error);
            document.getElementById("authorityError").textContent = "Произошла ошибка при сохранении.";
        });
}

function deleteRole(roleId) {
    fetch('/admin/roles/delete/' + roleId, {
        method: 'DELETE',
        headers: {
            'X-CSRF-TOKEN': document.getElementById("csrfToken").value
        }
    }).then(response => {
        if (response.ok) location.reload();
    });
}

function showModal(id) {
    document.getElementById(id).style.display = 'block';
}

function closeModal(id) {
    document.getElementById(id).style.display = 'none';
}