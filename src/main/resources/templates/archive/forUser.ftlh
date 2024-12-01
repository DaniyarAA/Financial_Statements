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

        .action-button {
            padding: 0.5rem 1rem;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background-color 0.3s ease;
        }

        .action-button:hover {
            background-color: #218838;
        }

        .no-data {
            text-align: center;
            color: #777;
            font-style: italic;
        }

        h2 {
            color: black !important;
        }

        .details-row {
            background-color: #f9f9f9;
            border-top: 1px solid #ddd;
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
    </style>


    <div class="tabs mt-5 mx-auto">
        <button class="tab-button active" onclick="showTab('tasks')">Завершенные задачи</button>
        <button class="tab-button" onclick="showTab('companies')">Удаленные компании</button>
    </div>

    <div id="tasks" class="tab-content">
        <h2>Завершенные задачи</h2>
        <table>
            <thead>
            <tr>
                <th>№</th>
                <th>Тип документа</th>
                <th>Дата начала</th>
                <th>Дата окончания</th>
                <th>Цена</th>
                <th>Описание</th>
            </tr>
            </thead>
            <tbody>
            <#if userFinishedTasks?has_content>
                <#list userFinishedTasks as task>
                    <tr>
                        <td>${task_index + 1}</td>
                        <td>${task.documentTypeName}</td>
                        <td>${task.startDate}</td>
                        <td>${task.endDate}</td>
                        <td>${task.amount}</td>
                        <td>${task.description}</td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="5" class="no-data mt-2 mx-auto">Нет завершенных задач</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

    <div id="companies" class="tab-content">
        <h2>Удаленные компании</h2>
        <table>
            <thead>
            <tr>
                <th>№</th>
                <th>Имя</th>
                <th>Подробнее</th>
                <th>Возобновить</th>
            </tr>
            </thead>
            <tbody>
            <#if deletedCompaniesByUser?has_content>
                <#list deletedCompaniesByUser as company>
                    <tr>
                        <td>${company_index+1}</td>
                        <td>${company.name}</td>
                        <td>
                            <button class="action-button" onclick="toggleDetails(${company.id})">Подробнее</button>
                        </td>
                        <td>
                            <button class="action-button" onclick="resumeCompany(${company.id})">Восстановить</button>
                        </td>
                    </tr>
                    <tr id="details-${company.id}" class="details-row" style="display: none;">
                        <td colspan="3">
                            <ul>
                                <li><b>ИНН:</b> ${company.companyInn}</li>
                                <li><b>ИНН директора:</b> ${company.directorInn}</li>
                                <li><b>Логин:</b> ${company.login}</li>
                                <li><b>Пароль:</b> ${company.password}</li>
                                <li><b>ЭЦП:</b> ${company.ecp}</li>
                                <li><b>Salyk.kg логин:</b> ${company.kabinetSalyk}</li>
                                <li><b>Salyk.kg пароль: </b> ${company.kabinetSalykPassword}</li>
                                <li><b>Режим налогообложения:</b> ${company.taxMode}</li>
                                <li><b>ОПФ:</b> ${company.opf}</li>
                                <li><b>Район ГНС:</b> ${company.districtGns}</li>
                                <li><b>Номер социального фонда:</b> ${company.socfundNumber}</li>
                                <li><b>Регистрационный номер МЮ:</b> ${company.registrationNumberMj}</li>
                                <li><b>ОКПО:</b> ${company.okpo}</li>
                                <li><b>ФИО руководителя:</b> ${company.director}</li>
                                <li><b>КЭД:</b> ${company.ked}</li>
                                <#if company.email ? has_content>
                                    <li><b>Почта:</b> ${company.email}</li>
                                </#if>

                                <#if company.emailPassword ? has_content>
                                    <li><b>Телефон:</b> ${company.emailPassword}</li>
                                </#if>
                                <#if company.phone ? has_content>
                                    <li><b>Телефон:</b> ${company.phone}</li>
                                </#if>
                                <#if company.esf ? has_content>
                                    <li><b>ЭСФ логин:</b> ${company.esf}</li>
                                </#if>
                                <#if company.esfPassword ? has_content>
                                    <li><b>ЭСФ пароль:</b> ${company.esfPassword}</li>
                                </#if>
                                <#if company.kkm ? has_content>
                                    <li><b>ККМ логин:</b> ${company.kkm}</li>
                                </#if>
                                <#if company.kkmPassword ? has_content>
                                    <li><b>ККМ пароль:</b> ${company.kkmPassword}</li>
                                </#if>
                                <#if company.fresh1c ? has_content>
                                    <li><b>1С Фреш логин:</b> ${company.fresh1c}</li>
                                </#if>
                                <#if company.fresh1cPassword ? has_content>
                                    <li><b>1С Фреш пароль:</b> ${company.fresh1cPassword}</li>
                                </#if>
                                <#if company.ettn ? has_content>
                                    <li><b>ЭТТН логин:</b> ${company.ettn}</li>
                                </#if>
                                <#if company.ettnPassword ? has_content>
                                    <li><b>ЭТТН пароль:</b> ${company.ettnPassword}</li>
                                </#if>

                            </ul>
                        </td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="3" class="no-data">Нет удаленных компаний</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>
</@layout.layout>

<script>
    const csrfToken = document.querySelector('meta[name="_csrf_token"]').getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

    function showTab(tabId) {
        const tabs = document.querySelectorAll('.tab-content');
        const buttons = document.querySelectorAll('.tab-button');

        tabs.forEach(tab => {
            tab.classList.remove('active');
        });

        buttons.forEach(button => {
            button.classList.remove('active');
        });

        document.getElementById(tabId).classList.add('active');
        const activeButton = document.querySelector('.tab-button[onclick="showTab(' + tabId + ')"]');
        if (activeButton) {
            activeButton.classList.add('active');
        }
    }

    function toggleDetails(companyId) {
        const detailsRow = document.getElementById('details-' + companyId);
        if (detailsRow.style.display === "none") {
            detailsRow.style.display = "table-row";
        } else {
            detailsRow.style.display = "none";
        }
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

    function showNotification(message, isSuccess = true) {
        const notification = document.createElement('div');
        notification.className = 'custom-notification' + isSuccess ? 'success' : 'error';
        notification.innerText = message;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.opacity = '0';
            setTimeout(() => notification.remove(), 500);
        }, 3000);
    }

</script>
