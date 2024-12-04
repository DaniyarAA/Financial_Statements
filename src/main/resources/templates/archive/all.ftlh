<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>
    <style>
        header {
            background-color: #4caf50;
            color: #fff;
            padding: 1rem 0;
            text-align: center;
        }

        header h1 {
            margin: 0;
            font-size: 1.5rem;
        }

        .tabs {
            display: flex;
            justify-content: space-evenly;
            margin-bottom: 1rem;
        }

        .tab-button {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            background-color: #4caf50;
            color: white;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .tab-button.active {
            background-color: #008000;
            font-weight: bold;
        }

        .tab-button:hover {
            background-color: #008000;
        }

        .tab-content {
            display: none;
            text-align: center;
        }

        .tab-content.active {
            display: block;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 1rem 0;
        }

        th, td {
            padding: 0.75rem;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #f0f0f0;
            font-weight: bold;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(3px); /* Эффект размытия фона */
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: #fff;
            padding: 2rem;
            border-radius: 10px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            position: relative;
            text-align: center;
            animation: fadeIn 0.3s ease-out;
            margin-top: 250px;
        }

        .modal-content h2 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: #333;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 1.5rem;
            color: #888;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .close:hover {
            color: #333;
        }

        #roleSelect, #statusSelect {
            width: 100%;
            padding: 0.5rem;
            margin: 1rem 0;
            font-size: 1rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
            color: #333;
        }

        .action-button {
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            background-color: #4caf50;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .action-button:hover {
            background-color: #45a049;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        @media (max-width: 768px) {
            .modal-content {
                max-width: 90%;
                padding: 1.5rem;
            }

            .modal-content h2 {
                font-size: 1.2rem;
            }

            #roleSelect {
                font-size: 0.9rem;
            }

            .action-button {
                font-size: 0.9rem;
            }
        }

        .no-data {
            text-align: center;
            color: #777;
            font-style: italic;
        }

        h2 {
            color: black !important;
        }

        .details-row ul {
            margin: 0;
            padding: 0.5rem;
            list-style: none;

            @media (max-width: 768px) {
                .tabs {
                    flex-direction: column;
                    gap: 0.5rem;
                }

                table {
                    font-size: 0.9rem;
                }
            }
        }

        .styled-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            font-size: 1rem;
            min-width: 600px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background: #fff;
        }

        .styled-table thead tr {
            background-color: #4caf50;
            color: #0e0620;
            text-align: left;
        }

        .styled-table th, .styled-table td {
            padding: 12px 15px;
            text-align: center;
        }

        .styled-table tbody tr:nth-child(even) {
            background-color: #f3f3f3;
        }

        .styled-table tbody tr:hover {
            background-color: #e2f1e2;
        }

        .accordion {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            overflow: hidden;
        }

        .accordion-item {
            border: none;
            margin: 10px;
            box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.1);
        }

        .accordion-button {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #495057;
        }

        .accordion-button:hover {
            background-color: #e9ecef;
            color: #212529;
        }

        .btn-resume {
            border:  none;
            color: black;
            font-size: 23px;
        }

        .btn-resume:hover {
            background-color: white;
            color: black;
        }

        .company-details {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .company-details li {
            margin: 5px 0;
            padding: 5px 10px;
            border-left: 4px solid #198754;
            background-color: #fff;
            border-radius: 5px;
            display: flex;
            align-items: center;
            font-size: 14px;
            color: #495057;
        }

        .company-details li i {
            margin-right: 10px;
            color: #198754;
        }

        .accordion-body {
            display: flex;
            flex-direction: column;
            justify-content: center;
            margin: 0 auto;
            padding: 15px;
            background-color: #f9f9f9;
            font-size: 14px;
            line-height: 1.5;
            border-radius: 5px;
            max-width: 1000px;
        }

        .company-details li b {
            color: #555;
        }

        .no-data {
            font-size: 18px;
            color: #888;
            text-align: center;
            display: block;
            margin-top: 20px;
        }

        .accordion-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-right: 15px;
        }

        .dataTables_wrapper {
            margin-top: 20px;
        }
        .dataTables_length label, .dataTables_filter label {
            font-weight: bold;
        }

    </style>


    <div class="tabs mt-5 mx-auto">
        <button class="tab-button active" onclick="showTab('users')">Удаленные пользователи</button>
        <button class="tab-button" onclick="showTab('tasks')">Завершенные задачи</button>
        <button class="tab-button" onclick="showTab('companies')">Удаленные компании</button>
    </div>

    <div id="users" class="tab-content active">
        <h2>Удаленные пользователи</h2>
        <table class="styled-table" id="users-table">
            <thead>
            <tr>
                <th>№</th>
                <th>Имя</th>
                <th>Фамилия</th>
                <th>Логин</th>
                <th>Адерс эл.почты</th>
                <th>День рождение</th>
                <th>Дата регистрации</th>
                <th>Действие</th>
            </tr>
            </thead>
            <tbody>
            <#if deletedUsers?has_content>
                <#list deletedUsers as user>
                    <tr>
                        <td>${user_index + 1}</td>
                        <td>${user.name}</td>
                        <td>${user.surname}</td>
                        <td>${user.login}</td>
                        <td>${user.email}</td>
                        <td>${user.birthday}</td>
                        <td>${user.registerDate}</td>
                        <td>
                            <button class="action-button" onclick="openModal(${user.id})">Восстановить</button>
                        </td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="7" class="no-data mt-2 mx-auto">Нет удаленных пользователей</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

    <div id="roleModal" class="modal">
        <div class="modal-content  mx-auto mt-5">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Выберите роль</h2>
            <select id="roleSelect">
                <#list roles as role>
                    <option value="${role.id}">${role.roleName}</option>
                </#list>
            </select>
            <button class="action-button" onclick="confirmRole()">Подтвердить</button>
        </div>
    </div>

    <div id="tasks" class="tab-content">
        <h2>Завершенные задачи</h2>
        <table class="styled-table">
            <thead>
            <tr>
                <th>№</th>
                <th>Компания</th>
                <th>ИНН компании</th>
                <th>Тип документа</th>
                <th>Дата начала</th>
                <th>Дата окончания</th>
                <th>Сумма</th>
                <th>Описание</th>
                <#--                <th>Файл</th>TODO добавить файл в миграции и потом на страницу-->
                <th>Действие</th>
            </tr>
            </thead>
            <tbody>
            <#if finishedTasks?has_content>
                <#list finishedTasks as task>
                    <tr>
                        <td>${task_index + 1}</td>
                        <td>${task.company.name}</td>
                        <td>${task.company.inn}</td>
                        <td>${task.documentTypeName}</td>
                        <td>${task.startDate}</td>
                        <td>${task.endDate}</td>
                        <td>${task.amount}</td>
                        <td>${task.description}</td>
                        <#--                        <td>${task.report}</td> TODO добавить файл в миграции и потом на страницу -->
                        <td>
                            <button class="action-button" onclick="openStatusModal(${task.id})">Восстановить</button>
                        </td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="9" class="no-data mt-2 mx-auto">Нет завершенных задач</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

    <div id="statusModal" class="modal">
        <div class="modal-content  mx-auto mt-5">
            <span class="close" onclick="closeStatusModal()">&times;</span>
            <h2>Выберите статус</h2>
            <select id="statusSelect">
                <#list statuses as status>
                    <option value="${status.id}">${status.name}</option>
                </#list>
            </select>
            <button class="action-button" onclick="confirmStatus()">Подтвердить</button>
        </div>
    </div>

    <div id="companies" class="tab-content">
        <h2 class="text-center">Удаленные компании</h2>
        <#if deletedCompanies?has_content>
            <div class="accordion shadow-sm rounded" id="accordionCompanies">
                <#list deletedCompanies as company>
                    <div class="accordion-item">
                        <h2 class="accordion-header d-flex align-items-center justify-content-between"
                            id="heading-${company_index}">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
                                    data-bs-target="#collapse-${company_index}" aria-expanded="false"
                                    aria-controls="collapse-${company_index}">
                                <span># ${company_index + 1} - ${company.name}</span>
                            </button>
                            <button class="btn btn-outline-success btn-sm ms-2 btn-resume"
                                    onclick="resumeCompany(${company.id})"
                                    title="Восстановить компанию ${company.name}">
                                <i class="bi bi-reply-all"></i>
                            </button>
                        </h2>
                        <div id="collapse-${company_index}" class="accordion-collapse collapse"
                             aria-labelledby="heading-${company_index}" data-bs-parent="#accordionCompanies">
                            <div class="accordion-body bg-light">
                                <div class="row row-cols-1 row-cols-md-2">
                                    <div class="col">
                                        <ul class="company-details">
                                            <li><i class="bi bi-info-circle"></i> <b>ИНН:</b> ${company.companyInn}</li>
                                            <li><i class="bi bi-person-circle"></i> <b>ИНН
                                                    директора:</b> ${company.directorInn}
                                            </li>
                                            <li><i class="bi bi-shield-lock"></i> <b>Логин:</b> ${company.login}</li>
                                            <li><i class="bi bi-key"></i> <b>Пароль:</b> ${company.password}</li>
                                            <li><i class="bi bi-person-badge"></i> <b>ЭЦП:</b> ${company.ecp}</li>
                                            <li><i class="bi bi-laptop"></i> <b>Salyk.kg
                                                    логин:</b> ${company.kabinetSalyk}</li>
                                            <li><i class="bi bi-key"></i> <b>Salyk.kg
                                                    пароль:</b> ${company.kabinetSalykPassword}</li>
                                            <li><i class="bi bi-bar-chart-line"></i> <b>Режим
                                                    налогообложения:</b> ${company.taxMode}</li>
                                            <li><i class="bi bi-building"></i> <b>ОПФ:</b> ${company.opf}</li>
                                            <li><i class="bi bi-map"></i> <b>Район ГНС:</b> ${company.districtGns}</li>
                                            <li><i class="bi bi-hospital"></i> <b>Номер социального
                                                    фонда:</b> ${company.socfundNumber}</li>
                                            <li><i class="bi bi-file-earmark"></i> <b>Регистрационный номер
                                                    МЮ:</b> ${company.registrationNumberMj}</li>
                                            <li><i class="bi bi-cash-stack"></i> <b>ОКПО:</b> ${company.okpo}</li>
                                        </ul>
                                    </div>
                                    <div class="col">
                                        <ul class="company-details">
                                            <li><i class="bi bi-person"></i> <b>ФИО
                                                    руководителя:</b> ${company.director}</li>
                                            <li><i class="bi bi-code-slash"></i> <b>КЭД:</b> ${company.ked}</li>
                                            <#if company.email?has_content>
                                                <li><i class="bi bi-envelope"></i> <b>Почта:</b> ${company.email}</li>
                                            </#if>
                                            <#if company.emailPassword?has_content>
                                                <li><i class="bi bi-key"></i> <b>Пароль
                                                        почты:</b> ${company.emailPassword}</li>
                                            </#if>
                                            <#if company.phone?has_content>
                                                <li><i class="bi bi-telephone"></i> <b>Телефон:</b> ${company.phone}
                                                </li>
                                            </#if>
                                            <#if company.esf?has_content>
                                                <li><i class="bi bi-server"></i> <b>ЭСФ логин:</b> ${company.esf}</li>
                                            </#if>
                                            <#if company.esfPassword?has_content>
                                                <li><i class="bi bi-key"></i> <b>ЭСФ пароль:</b> ${company.esfPassword}
                                                </li>
                                            </#if>
                                            <#if company.kkm?has_content>
                                                <li><i class="bi bi-credit-card"></i> <b>ККМ логин:</b> ${company.kkm}
                                                </li>
                                            </#if>
                                            <#if company.kkmPassword?has_content>
                                                <li><i class="bi bi-key"></i> <b>ККМ пароль:</b> ${company.kkmPassword}
                                                </li>
                                            </#if>
                                            <#if company.fresh1c?has_content>
                                                <li><i class="bi bi-archive"></i> <b>1С Фреш
                                                        логин:</b> ${company.fresh1c}</li>
                                            </#if>
                                            <#if company.fresh1cPassword?has_content>
                                                <li><i class="bi bi-key"></i> <b>1С Фреш
                                                        пароль:</b> ${company.fresh1cPassword}
                                                </li>
                                            </#if>
                                            <#if company.ettn?has_content>
                                                <li><i class="bi bi-barcode"></i> <b>ЭТТН логин:</b> ${company.ettn}
                                                </li>
                                            </#if>
                                            <#if company.ettnPassword?has_content>
                                                <li><i class="bi bi-key"></i> <b>ЭТТН
                                                        пароль:</b> ${company.ettnPassword}</li>
                                            </#if>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        <#else>
            <span class="text-center text-muted">Нет удаленных компаний</span>
        </#if>
    </div>
</@layout.layout>

<script>
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

    function toggleDetails(companyId) {
        const detailsRow = document.getElementById('details-' + companyId);
        if (detailsRow.style.display === "none") {
            detailsRow.style.display = "table-row";
        } else {
            detailsRow.style.display = "none";
        }
    }

    let selectedUserId;
    let selectTaskId;

    function openModal(userId) {
        selectedUserId = userId;
        document.getElementById('roleModal').style.display = 'block';
    }

    function openStatusModal(taskId) {
        selectTaskId = taskId;
        document.getElementById('statusModal').style.display = 'block';
    }

    function closeModal() {
        selectedUserId = null;
        document.getElementById('roleModal').style.display = 'none';
    }

    function closeStatusModal() {
        selectTaskId = null;
        document.getElementById('statusModal').style.display = 'none';
    }


    function confirmRole() {
        const roleId = document.getElementById('roleSelect').value;
        if (!roleId) {
            alert('Выберите роль.');
            return;
        }

        resumeUserWithRole(selectedUserId, roleId);
        closeModal();
    }

    function showNotification(message, success) {
        const alert = document.createElement('div');
        alert.className = 'alert ' + success ? 'alert-success' : 'alert-danger' + ' fade show position-fixed top-0 end-0 m-3';
        alert.role = 'alert';
        alert.textContent = message;

        document.body.appendChild(alert);

        setTimeout(() => {
            alert.classList.remove('show');
            setTimeout(() => alert.remove(), 300);
        }, 3000);
    }

    document.addEventListener('DOMContentLoaded', () => {
        const activeTab = localStorage.getItem('activeTab');
        if (activeTab) {
            showTab(activeTab);
        }
    });

    function showTab(tabId) {
        const tabs = document.querySelectorAll('.tab-content');
        const buttons = document.querySelectorAll('.tab-button');

        tabs.forEach(tab => tab.classList.remove('active'));
        buttons.forEach(button => button.classList.remove('active'));

        document.getElementById(tabId).classList.add('active');
        document.querySelector('.tab-button[onclick="showTab(' + tabId + ')"]').classList.add('active');

        localStorage.setItem('activeTab', tabId);
    }

    function resumeCompany(companyId) {
        fetch('/archive/resume/company/' + companyId, {
            method: "POST",
            headers: {
                [csrfHeader]: csrfToken
            }
        })
            .then(response => {
                if (response.ok) {
                    showNotification('Компания успешно восстановлена!', true);
                    localStorage.setItem('activeTab', 'companies');
                    location.reload();
                } else {
                    showNotification('Ошибка при восстановлении компании.', false);
                }
            })
            .catch(error => showNotification('Ошибка: ' + error.message, false));
    }

    function resumeUserWithRole(userId, roleId) {
        fetch('/archive/resume/user/' + userId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({roleId})
        })
            .then(response => {
                if (response.ok) {
                    showNotification('Пользователь успешно восстановлен!', true);
                    localStorage.setItem('activeTab', 'users');
                    location.reload();
                } else {
                    showNotification('Ошибка при восстановлении пользователя.', false);
                }
            })
            .catch(error => showNotification('Ошибка: ' + error.message, false));
    }

    function confirmStatus() {
        const statusId = document.getElementById('statusSelect').value;
        if (!statusId) {
            alert('Выберите Статус.');
            return;
        }

        updateTaskStatus(selectTaskId, statusId);
        closeStatusModal();
    }

    function updateTaskStatus(taskId, statusId) {
        fetch('/archive/change_status/' + taskId, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader]: csrfToken
            },
            body: JSON.stringify({statusId})
        })
            .then(response => {
                if (response.ok) {
                    showNotification('Задача успешно изменила статус!', true);
                    localStorage.setItem('activeTab', 'tasks');
                    location.reload();
                } else {
                    response.text().then(errorMessage => showNotification('Ошибка: ' + errorMessage, false));
                }
            })
            .catch(error => showNotification('Ошибка: ' + error.message, false));
    }
</script>
