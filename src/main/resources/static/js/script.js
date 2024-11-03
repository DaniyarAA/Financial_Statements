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

function openEditRoleModal(roleId, roleName) {
    document.getElementById("editRoleId").value = roleId;
    document.getElementById("editRoleName").value = roleName;

    fetch('/admin/roles/edit/' + roleId)
        .then(response => response.json())
        .then(data => {
            const container = document.getElementById("editAuthoritiesContainer");
            container.innerHTML = "";

            data.authorities.forEach(authority => {
                const checked = authority.selected ? 'checked' : '';
                container.innerHTML += `<div class="form-check">
                    <input type="checkbox" id="edit_auth_${authority.id}" name="authorities" value="${authority.id}" class="form-check-input" ${checked}>
                    <label for="edit_auth_${authority.id}" class="form-check-label">${authority.authorityName}</label>
                </div>`;
            });
            showModal('editRoleModal');
        })
        .catch(error => console.error('Error loading role data:', error));
}

function openCreateRoleModal() {
    document.getElementById("createRoleName").value = "";
    document.querySelectorAll('#createRoleModal input[name="authorityIds"]').forEach(input => input.checked = false);
    showModal('createRoleModal');
}

function createRole() {
    const roleName = document.getElementById("createRoleName").value;
    const authorities = Array.from(document.querySelectorAll('#createRoleModal input[name="authorityIds"]:checked')).map(input => input.value);

    fetch('/admin/roles/create', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.getElementById("csrfToken").value
        },
        body: JSON.stringify({ roleName, authorityIds: authorities })
    }).then(response => {
        if (response.ok) location.reload();
    });
}

function saveRole() {
    const roleId = document.getElementById("editRoleId").value;
    const roleName = document.getElementById("editRoleName").value;
    const authorities = Array.from(document.querySelectorAll('#editRoleModal input[name="authorities"]:checked')).map(input => input.value);

    fetch('/admin/roles/edit/' + roleId, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-TOKEN': document.getElementById("csrfToken").value
        },
        body: JSON.stringify({ id: roleId, roleName,  authorities })
    }).then(response => {
        if (response.ok) location.reload();
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