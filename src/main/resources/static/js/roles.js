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