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


document.addEventListener("DOMContentLoaded", function () {
    const userModal = document.getElementById("userModal");
    function handleSaveUserData(userId) {
        saveUserData(userId);
    }


    userModal.addEventListener("show.bs.modal", function (event) {
        const button = event.relatedTarget;
        const avatarInput = document.getElementById("avatarInput");
        const deleteUserIcon = document.getElementById("delete-user-icon");
        const userId = button.getAttribute("data-user-id");
        deleteUserIcon.setAttribute("data-user-id", userId);
        avatarInput.setAttribute("data-user-id", userId);

        fetch(`/admin/users/edit/` + userId)
            .then(response => response.json())
            .then(data => {
                const user = data.user;
                const companies = data.companies;
                const roles = data.roles;

                document.getElementById("userModalLabel").innerText = user.name;
                const birthday = user.birthday;
                const [year, month, day] = birthday.split('-');
                document.getElementById("user-birthday").innerText = `${month}.${day}.${year}`;
                document.getElementById("user-status").innerText = user.enabled ? "Активен" : "Неактивен";
                document.getElementById("notesInput").value = user.notes;
                document.getElementById("userNameInput").value = user.name;
                document.getElementById("birthday-input").value = birthday;
                if (user.avatar) {
                    document.getElementById("avatar").src = `/api/files/download/${user.avatar}`;
                } else {
                    document.getElementById("avatar").src = `/user.png`;

                }

                const roleDisplay = document.getElementById("roleDisplay");
                const roleSelect = document.getElementById("roleSelect");
                roleDisplay.innerText = user.roleDto.roleName;
                roleSelect.innerHTML = "";
                roles.forEach(role => {
                    const option = document.createElement("option");
                    option.value = role.id;
                    option.textContent = role.roleName;
                    if (role.id === user.roleDto.id) {
                        option.selected = true;
                    }
                    roleSelect.append(option);
                });

                const initialCompanies = document.getElementById("initialCompanies");
                initialCompanies.innerHTML = user.companies.slice(0, 1).map(company => company.name).join(", ");
                if (user.companies.length > 1) {
                    initialCompanies.innerHTML += ", ...";
                } else if (user.companies.length === 0){
                    initialCompanies.innerHTML += "Отсутствуют"
                }

                const companyCheckboxes = document.getElementById("companyCheckboxes");
                companyCheckboxes.innerHTML = "";
                const sortedCompanies = companies.sort((a, b) => {
                    const aChecked = user.companies.some(userCompany => userCompany.id === a.id);
                    const bChecked = user.companies.some(userCompany => userCompany.id === b.id);
                    return bChecked - aChecked;
                });

                sortedCompanies.forEach((company, index) => {
                    const checkbox = document.createElement("input");
                    checkbox.type = "checkbox";
                    checkbox.value = company.id;
                    checkbox.id = `company_${company.id}`;
                    checkbox.checked = user.companies.some(userCompany => userCompany.id === company.id);

                    const label = document.createElement("label");
                    label.setAttribute("for", `company_${company.id}`);
                    label.textContent = `${index + 1}) ${company.name}`;

                    const div = document.createElement("div");
                    div.style.display = "flex";
                    div.style.justifyContent = "space-between";
                    div.style.alignItems = "center";

                    div.append(label);
                    div.append(checkbox);

                    companyCheckboxes.append(div);
                });
                const editUserBtn = document.querySelector(".edit-user-btn");
                editUserBtn.removeEventListener("click", handleSaveUserData);
                editUserBtn.addEventListener("click", () => handleSaveUserData(userId));

            })
            .catch(error => console.error("Error loading user data:", error));
    });
});

function uploadAvatar() {
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    const avatarInput = document.getElementById("avatarInput");
    const avatarImg = document.getElementById("avatar");
    const userId = avatarInput.getAttribute("data-user-id");

    avatarInput.onchange = async function() {
        const file = avatarInput.files[0];
        if (!file) {
            alert("Файл не выбран.");
            return;
        }

        const formData = new FormData();
        formData.append("file", file);

        try {
            const response = await fetch(`/api/files/upload/avatar/${userId}`, {
                method: "POST",
                headers: {
                    [csrfHeader]: csrfToken
                },
                body: formData
            });

            const data = await response.json();
            if (data.success) {
                const resultFileName = data.resultFileName;
                avatarImg.src = `/api/files/download/${resultFileName}`;
                showNotification("Аватарка успешно обновлена!", "green");
            } else {
                showNotification("Ошибка при обновлении аватарки.", "red");
            }
        } catch (error) {
            console.error("Ошибка:", error);
            showNotification("Произошла ошибка при отправке запроса.", "red");
        }
    };

    avatarInput.click();
}




let isSaving = false;
function saveUserData(userId) {
    if (isSaving) {
        return;
    }
    isSaving = true;
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    const roleSelect = document.getElementById("roleSelect");
    const username = document.getElementById("userNameInput").value;
    const birthday = document.getElementById("birthday-input").value;
    const selectedRoleDto = {
        id: roleSelect.value,
        roleName: roleSelect.options[roleSelect.selectedIndex].textContent
    };
    const notes = document.getElementById("notesInput").value;
    const companies = Array.from(document.querySelectorAll("#companyCheckboxes input:checked")).map(checkbox => {
        const label = document.querySelector(`label[for="${checkbox.id}"]`);
        return {
            id: checkbox.value,
            name: label ? label.textContent.trim() : ""
        };
    });
    console.log("Companies being sent:", companies);


    const userDto = {
        roleDto: selectedRoleDto,
        notes: notes,
        companies: companies,
        name: username,
        birthday: birthday

    };

    fetch(`/admin/users/edit/` + userId, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            [csrfHeader]: csrfToken
        },
        body: JSON.stringify(userDto)
    })
        .then(response => {
            isSaving = false;
            if (response.ok) {
                showNotification("Информация успешно обновлена", "green");
            } else {
                return response.json().then(errorData => {
                    const errorMessage = errorData.message || "Ошибка при обновлении информации";
                    showNotification(errorMessage, "red");
                });
            }
        })
        .catch(error => console.error("Error saving user data:", error));
}



function deleteUser() {
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    const deleteUserIcon = document.getElementById("delete-user-icon");
    const userStatus = document.getElementById("user-status");
    const userId = deleteUserIcon.getAttribute("data-user-id");
    if (confirm('Вы уверены, что хотите удалить этого пользователя?')) {
        fetch('/admin/user/delete/' + userId, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            }
        })
            .then(response => {
                if (response.ok) {
                    showNotification("Пользователь успешно удалён.", "green");
                    userStatus.innerText = "Неактивен"
                } else {
                    showNotification("Ошибка при удалении пользователя.", "red");
                }
            })
            .catch(error => {
                console.error('Ошибка:', error);
                showNotification("Ошибка при удалении пользователя.", "red");
            });
    }
}



function showNotification(message, color) {
    const notification = document.getElementById("notification");
    notification.textContent = message;
    notification.style.display = "block";
    notification.style.opacity = "1";
    notification.style.backgroundColor = color;

    setTimeout(() => {
        notification.style.opacity = "0";
        setTimeout(() => {
            notification.style.display = "none";
        }, 500);
    }, 3000);
}
function toggleCompanyEdit() {
    const initialCompanies = document.getElementById('initialCompanies');
    const companyDropdown = document.getElementById('companyDropdown');
    const editIcon = document.getElementById('edit-company-icon');
    if (companyDropdown.style.display === 'none') {
        initialCompanies.style.display = 'none';
        companyDropdown.style.display = 'inline-block';
        editIcon.style.display = 'none';
    } else {
        closeDropdown();
    }
}

function closeDropdown() {
    const initialCompanies = document.getElementById('initialCompanies');
    const companyDropdown = document.getElementById('companyDropdown');
    const editIcon = document.getElementById('edit-company-icon');

    initialCompanies.style.display = 'inline';
    companyDropdown.style.display = 'none';
    editIcon.style.display = 'inline';

    document.removeEventListener('click', closeDropdown);
}

document.addEventListener('click', function(event) {
    const companyDropdown = document.getElementById('companyDropdown');
    const editIcon = document.getElementById('edit-company-icon');

    if (!companyDropdown.contains(event.target) && event.target !== editIcon) {
        closeDropdown();
    }
});





function toggleRoleEdit() {
    const roleDisplay = document.getElementById('roleDisplay');
    const roleSelect = document.getElementById('roleSelect');
    if (roleSelect.style.display === 'none') {
        roleDisplay.style.display = 'none';
        roleSelect.style.display = 'inline-block';
    } else {
        roleDisplay.innerText = roleSelect.options[roleSelect.selectedIndex].textContent;
        roleDisplay.style.display = 'inline';
        roleSelect.style.display = 'none';
    }
}

function toggleNameEdit() {
    const userModalLabel = document.getElementById('userModalLabel');
    const userNameInput = document.getElementById('userNameInput');
    if (userNameInput.style.display === 'none') {
        userNameInput.style.display = 'inline-block';
        userModalLabel.style.display = 'none';
        userNameInput.value = userModalLabel.innerText;
        userNameInput.focus();
    } else {
        userModalLabel.innerText = userNameInput.value;
        userModalLabel.style.display = 'block';
        userNameInput.style.display = 'none';

    }
}

function toggleBirthdayEdit() {
    const birthdayDisplay = document.getElementById("user-birthday");
    const birthdayInput = document.getElementById("birthday-input");

    if (birthdayInput.style.display === 'none') {
        const displayDate = birthdayDisplay.innerText;
        const dateParts = displayDate.split('.');
        birthdayInput.value = `${dateParts[2]}-${dateParts[0]}-${dateParts[1]}`;
        birthdayInput.style.display = 'inline-block';
        birthdayDisplay.style.display = 'none';
    } else {
        const dateParts = birthdayInput.value.split('-');
        birthdayDisplay.innerText = `${dateParts[1]}.${dateParts[2]}.${dateParts[0]}`;
        birthdayDisplay.style.display = 'inline';
        birthdayInput.style.display = 'none';
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