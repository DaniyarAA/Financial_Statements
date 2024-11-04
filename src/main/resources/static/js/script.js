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
        const userId = button.getAttribute("data-user-id");

        fetch(`/admin/users/edit/` + userId)
            .then(response => response.json())
            .then(data => {
                const user = data.user;
                const companies = data.companies;
                const roles = data.roles;

                document.getElementById("userModalLabel").innerText = user.name;
                const birthday = new Date(user.birthday);
                document.getElementById("user-birthday").innerText = birthday.toLocaleDateString("ru-RU");
                document.getElementById("user-status").innerText = user.enabled ? "Активен" : "Неактивен";
                document.getElementById("notesInput").value = user.notes;

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

let isSaving = false;
function saveUserData(userId) {
    if (isSaving) {
        return;
    }
    isSaving = true;
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');
    const roleSelect = document.getElementById("roleSelect");
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
        companies: companies

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
    console.log('432423423')
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
