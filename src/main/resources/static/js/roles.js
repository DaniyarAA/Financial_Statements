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
                body: JSON.stringify({roleName, authorityIds})
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

    if (roleName !== "Бухгалтер" && document.getElementById("editRoleId").value) {
        document.getElementById("roleNameError").textContent = "Название роли 'Бухгалтер' не может быть изменено.";
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
            authorities: selectedAuthorities.map(id => ({id: parseInt(id)}))
        })
    })
        .then(response => {
            if (response.ok) {
                closeModal("editRoleModal");
                location.reload();
            } else {
                return response.json();
            }
        })
        .then(data => {
            if (data && data.error) {
                if (data.error === "duplicate") {
                    document.getElementById("roleNameError").textContent = "Роль с таким именем уже существует.";
                }
            }
        })
        .catch(error => console.error("Ошибка при сохранении роли:", error));
}

function deleteRole(roleId, roleName) {
    if (roleName === 'Бухгалтер') {
        alert("Роль 'Бухгалтер' нельзя удалить.");
        return;
    }

    fetch('/admin/roles/delete/' + roleId, {
        method: 'DELETE',
        headers: {
            'X-CSRF-TOKEN': document.getElementById("csrfToken").value
        }
    }).then(response => {
        if (!response.ok) {
            return response.json().then(error => {
                alert(`Ошибка: ${error.message}`);
            });
        }
        location.reload();
    }).catch(error => console.error('Error:', error));
}

function showModal(id) {
    document.getElementById(id).style.display = 'block';
}

function closeModal(id) {
    document.getElementById(id).style.display = 'none';
}

function openEditRoleModal(roleId) {
    document.getElementById("editRoleId").value = roleId;
    const authoritiesContainer = document.getElementById("editAuthoritiesContainer");
    authoritiesContainer.innerHTML = "";

    fetch('/admin/roles/edit/' + roleId)
        .then(response => response.json())
        .then(roleDto => {
            document.getElementById("editRoleId").value = roleDto.id;
            const editRoleNameInput = document.getElementById("editRoleName");
            editRoleNameInput.value = roleDto.roleName;

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