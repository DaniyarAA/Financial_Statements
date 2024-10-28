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