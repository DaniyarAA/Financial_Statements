<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="/css/archive/archive.css">

    <div class="tabs mx-auto">
        <button class="tab-button active" onclick="showTab('users')">Удаленные пользователи</button>
        <button class="tab-button" onclick="showTab('tasks')">Завершенные задачи</button>
        <button class="tab-button" onclick="showTab('companies')">Удаленные компании</button>
    </div>

    <div id="users" class="tab-content user-main-div active">
        <table class="styled-table styled-table-user user-table-main" id="users-table">
            <thead class="thead-user-archive">
            <tr>
                <th class="th-user-archive">№</th>
                <th class="th-user-archive">ФИО</th>
                <th class="th-user-archive">Логин</th>
                <th class="th-user-archive">Адрес эл. почты</th>
                <th class="th-user-archive">День рождения</th>
                <th class="th-user-archive">Дата регистрации</th>
            </tr>
            </thead>
            <tbody class="tbody-user-archive">
            <#if deletedUsers?has_content>
                <#list deletedUsers as user>
                    <tr class="tr-user-archive" id="${user.id}-tr">
                        <td class="th-user-archive return-button-list-td"><button class="btn btn-light btn-return-user-in-list" onclick="openModal(${user.id})" title="Восстановить пользователя : ${user.name}"><i class="bi bi-rewind-fill return-list-icon" style="color: #1E1E1E"></i>  ${user_index + 1}</button>
                          </td>
                        <td class="th-user-archive">${user.name} ${user.surname}</td>
                        <td class="th-user-archive">${user.login}</td>
                        <td class="th-user-archive">${user.email}</td>
                        <td class="th-user-archive">${user.birthday}</td>
                        <td class="th-user-archive">${user.registerDate}</td>
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
            <label for="roleSelect"><h2>Выберите роль</h2></label>
            <select id="roleSelect">
                <#list roles as role>
                    <option value="${role.id}">${role.roleName}</option>
                </#list>
            </select>
            <div class="d-flex justify-content-center">
            <button type="button" class="btn btn-success choose-role-btn" onclick="confirmRole()"><i class="bi bi-check2 check-icon-choose-role"></i></button>
            </div>
        </div>
    </div>

    <div id="tasks" class="tab-content">
        <select id="filterDocumentType" class="form-control main-title-item w-auto">
            <option value="">Все типы документов</option>
            <#list documentTypes as type>
                <option value="${type.name}">${type.name}</option>
            </#list>
        </select>
        <table id="tasksTable" class="styled-table styled-table-task">
            <thead class="thead-task-archive">
            <tr>
                <th class="th-task-archive">Компания</th>
                <th class="th-task-archive">ИНН компании</th>
                <th class="th-task-archive">Тип документа</th>
                <th class="th-task-archive">Дата начала</th>
                <th class="th-task-archive">Дата окончания</th>
                <th class="th-task-archive">Сумма</th>
                <th class="th-task-archive">Файл</th>
                <th class="th-task-archive">Изменить статус</th>
            </tr>
            </thead>
            <tbody>
            <#if finishedTasks?has_content>
                <#list finishedTasks as task>
                    <tr data-task-id="${task.id}">
                        <td class="td-task-archive  td-task-archive-top">${task.company.name}</td>
                        <td class="td-task-archive">${task.company.inn}</td>
                        <td class="td-task-archive">${task.documentTypeName}</td>
                        <td class="td-task-archive">${task.startDate}</td>
                        <td class="td-task-archive">${task.endDate}</td>
                        <td class="td-task-archive">${task.amount}</td>
                        <td class="td-task-archive">Здесь должен быть прикрепленный файл</td>
                        <td class="td-task-archive">
                            <select class="status-dropdown"
                                    data-original-status="${task.statusId}"
                                    onchange="openStatusModal(${task.id}, '${task.company.name}', this)">
                                <#list statuses as status>
                                    <option value="${status.id}"
                                            <#if status.name == task.statusId>selected</#if>
                                            <#if status.name == 'Сдан'>disabled</#if>>
                                        ${status.name}
                                    </option>
                                </#list>
                            </select>
                        </td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="8" class="no-data mt-2 mx-auto">Нет завершенных задач</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

    <div id="statusModal" class="modal">
        <div class="modal-content mx-auto mt-5">
            <div class="modal-body" id="confirmMessage">
                <p>Вы уверены, что хотите изменить статус для задачи "<span id="taskName"></span>"?</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary"
                        onclick="closeStatusModal()" >Отмена
                </button>
                <button class="btn btn-danger" onclick="confirmStatus()">ДА</button>
            </div>
        </div>
    </div>

    <div id="companies" class="tab-content">

        <div class="d-flex justify-content-center">

        <input type="text" id="searchCompanies" placeholder="Поиск по имени компании..." class="form-control mb-3">

        </div>

        <#if deletedCompanies?has_content>
            <div class="accordion rounded" id="accordionCompanies">
                <#list deletedCompanies as company>
                    <div class="accordion-item" id="${company.id}-item">
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
                                            <li><i class="bi bi-info-circle" style="color: #1E1E1E"></i> <b>ИНН:</b> ${company.companyInn}
                                            </li>
                                            <li><i class="bi bi-person-circle" style="color: #1E1E1E"></i> <b>ИНН
                                                    директора:</b> ${company.directorInn}
                                            </li>
                                            <li><i class="bi bi-shield-lock" style="color: #1E1E1E"></i> <b>Логин:</b> ${company.login}
                                            </li>
                                            <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>Пароль:</b> ${company.password}</li>
                                            <li><i class="bi bi-person-badge" style="color: #1E1E1E"></i> <b>ЭЦП:</b> ${company.ecp}</li>
                                            <li><i class="bi bi-laptop" style="color: #1E1E1E"></i> <b>Salyk.kg
                                                    логин:</b> ${company.kabinetSalyk}</li>
                                            <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>Salyk.kg
                                                    пароль:</b> ${company.kabinetSalykPassword}</li>
                                            <li><i class="bi bi-bar-chart-line" style="color: #1E1E1E"></i> <b>Режим
                                                    налогообложения:</b> ${company.taxMode}</li>
                                            <li><i class="bi bi-building" style="color: #1E1E1E"></i> <b>ОПФ:</b> ${company.opf}</li>
                                            <li><i class="bi bi-map" style="color: #1E1E1E"></i> <b>Район ГНС:</b> ${company.districtGns}
                                            </li>
                                            <li><i class="bi bi-hospital" style="color: #1E1E1E"></i> <b>Номер социального
                                                    фонда:</b> ${company.socfundNumber}</li>
                                            <li><i class="bi bi-file-earmark" style="color: #1E1E1E"></i> <b>Регистрационный номер
                                                    МЮ:</b> ${company.registrationNumberMj}</li>
                                            <li><i class="bi bi-cash-stack" style="color: #1E1E1E"></i> <b>ОКПО:</b> ${company.okpo}</li>
                                        </ul>
                                    </div>
                                    <div class="col">
                                        <ul class="company-details">
                                            <li><i class="bi bi-person" style="color: #1E1E1E"></i> <b>ФИО
                                                    руководителя:</b> ${company.director}</li>
                                            <li><i class="bi bi-code-slash" style="color: #1E1E1E"></i> <b>КЭД:</b> ${company.ked}</li>
                                            <#if company.email?has_content>
                                                <li><i class="bi bi-envelope" style="color: #1E1E1E"></i> <b>Почта:</b> ${company.email}
                                                </li>
                                            </#if>
                                            <#if company.emailPassword?has_content>
                                                <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>Пароль
                                                        почты:</b> ${company.emailPassword}</li>
                                            </#if>
                                            <#if company.phone?has_content>
                                                <li><i class="bi bi-telephone" style="color: #1E1E1E"></i> <b>Телефон:</b> ${company.phone}
                                                </li>
                                            </#if>
                                            <#if company.esf?has_content>
                                                <li><i class="bi bi-server" style="color: #1E1E1E"></i> <b>ЭСФ логин:</b> ${company.esf}
                                                </li>
                                            </#if>
                                            <#if company.esfPassword?has_content>
                                                <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>ЭСФ
                                                        пароль:</b> ${company.esfPassword}
                                                </li>
                                            </#if>
                                            <#if company.kkm?has_content>
                                                <li><i class="bi bi-credit-card" style="color: #1E1E1E"></i> <b>ККМ
                                                        логин:</b> ${company.kkm}
                                                </li>
                                            </#if>
                                            <#if company.kkmPassword?has_content>
                                                <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>ККМ
                                                        пароль:</b> ${company.kkmPassword}
                                                </li>
                                            </#if>
                                            <#if company.fresh1c?has_content>
                                                <li><i class="bi bi-archive" style="color: #1E1E1E"></i> <b>1С Фреш
                                                        логин:</b> ${company.fresh1c}</li>
                                            </#if>
                                            <#if company.fresh1cPassword?has_content>
                                                <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>1С Фреш
                                                        пароль:</b> ${company.fresh1cPassword}
                                                </li>
                                            </#if>
                                            <#if company.ettn?has_content>
                                                <li><i class="bi bi-truck" style="color: #1E1E1E"></i> <b>ЭТТН логин:</b> ${company.ettn}
                                                </li>
                                            </#if>
                                            <#if company.ettnPassword?has_content>
                                                <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>ЭТТН
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

<script src="/js/archive.js"></script>