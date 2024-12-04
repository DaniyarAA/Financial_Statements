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
        .accordion-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-right: 15px;
        }

        .btn-resume {
            background: none;
            border: none;
            color: black;
            font-size: 30px;
            cursor: pointer;
            transition: color 0.3s;
        }

        .btn-resume:hover {
            color: #C20B18;
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
        <button class="tab-button" onclick="showTab('tasks')">Завершенные задачи</button>
        <button class="tab-button" onclick="showTab('companies')">Удаленные компании</button>
    </div>

    <div id="tasks" class="tab-content">
        <h2>Завершенные задачи</h2>
        <table>
            <thead>
            <tr>
                <th>№</th>
                <th>Компания</th>
                <th>ИНН компании</th>
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
                        <td>${task.company.name}</td>
                        <td>${task.company.inn}</td>
                        <td>${task.documentTypeName}</td>
                        <td>${task.startDate}</td>
                        <td>${task.endDate}</td>
                        <td>${task.amount}</td>
                        <td>${task.description}</td>
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

    <div id="companies" class="tab-content active">
        <h2 class="text-center">Удаленные компании</h2>
        <#if deletedCompaniesByUser?has_content>
            <div class="accordion shadow-sm rounded" id="accordionCompanies">
                <#list deletedCompaniesByUser as company>
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

    function showTab(tabId) {
        const tabs = document.querySelectorAll('.tab-content');
        const buttons = document.querySelectorAll('.tab-button');

        tabs.forEach(tab => tab.classList.remove('active'));
        buttons.forEach(button => button.classList.remove('active'));

        document.getElementById(tabId).classList.add('active');
        document.querySelector('.tab-button[onclick="showTab(' + tabId + ')"]').classList.add('active');

        localStorage.setItem('activeTab', tabId);
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
