<#import '../layout.ftlh' as layout>
<@layout.layout ; spring>

    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <link rel="stylesheet" href="/css/archive/archive.css">

    <div class="tabs mx-auto">
        <button class="tab-button active" onclick="showTab('companies')">Удаленные компании</button>
        <button class="tab-button" onclick="showTab('users')">Удаленные пользователи</button>
        <button class="tab-button" onclick="showTab('tasks')">Завершенные задачи</button>
    </div>

    <div id="companies" class="tab-content active">

        <div class="d-flex justify-content-center">

            <input type="text" id="searchCompanies" placeholder="Поиск по имени компании..." class="form-control mb-3">

        </div>

        <#if deletedCompanies.content?has_content>
            <div class="accordion rounded" id="accordionCompanies">
                <#list deletedCompanies.content as company>
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
                                            <li><i class="bi bi-info-circle" style="color: #1E1E1E"></i>
                                                <b>ИНН:</b> ${company.companyInn}
                                            </li>
                                            <li><i class="bi bi-person-circle" style="color: #1E1E1E"></i> <b>ИНН
                                                    директора:</b> ${company.directorInn}
                                            </li>
                                            <li><i class="bi bi-shield-lock" style="color: #1E1E1E"></i>
                                                <b>Логин:</b> ${company.login}
                                            </li>
                                            <li><i class="bi bi-key" style="color: #1E1E1E"></i>
                                                <b>Пароль:</b> ${company.password}</li>
                                            <li><i class="bi bi-person-badge" style="color: #1E1E1E"></i>
                                                <b>ЭЦП:</b> ${company.ecp}</li>
                                            <li><i class="bi bi-laptop" style="color: #1E1E1E"></i> <b>Salyk.kg
                                                    логин:</b> ${company.kabinetSalyk}</li>
                                            <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>Salyk.kg
                                                    пароль:</b> ${company.kabinetSalykPassword}</li>
                                            <li><i class="bi bi-bar-chart-line" style="color: #1E1E1E"></i> <b>Режим
                                                    налогообложения:</b> ${company.taxMode}</li>
                                            <li><i class="bi bi-building" style="color: #1E1E1E"></i>
                                                <b>ОПФ:</b> ${company.opf}</li>
                                            <li><i class="bi bi-map" style="color: #1E1E1E"></i> <b>Район
                                                    ГНС:</b> ${company.districtGns}
                                            </li>
                                            <li><i class="bi bi-hospital" style="color: #1E1E1E"></i> <b>Номер
                                                    социального
                                                    фонда:</b> ${company.socfundNumber}</li>
                                            <li><i class="bi bi-file-earmark" style="color: #1E1E1E"></i> <b>Регистрационный
                                                    номер
                                                    МЮ:</b> ${company.registrationNumberMj}</li>
                                            <li><i class="bi bi-cash-stack" style="color: #1E1E1E"></i>
                                                <b>ОКПО:</b> ${company.okpo}</li>
                                        </ul>
                                    </div>
                                    <div class="col">
                                        <ul class="company-details">
                                            <li><i class="bi bi-person" style="color: #1E1E1E"></i> <b>ФИО
                                                    руководителя:</b> ${company.director}</li>
                                            <li><i class="bi bi-code-slash" style="color: #1E1E1E"></i>
                                                <b>КЭД:</b> ${company.ked}</li>
                                            <#if company.email?has_content>
                                                <li><i class="bi bi-envelope" style="color: #1E1E1E"></i>
                                                    <b>Почта:</b> ${company.email}
                                                </li>
                                            </#if>
                                            <#if company.emailPassword?has_content>
                                                <li><i class="bi bi-key" style="color: #1E1E1E"></i> <b>Пароль
                                                        почты:</b> ${company.emailPassword}</li>
                                            </#if>
                                            <#if company.phone?has_content>
                                                <li><i class="bi bi-telephone" style="color: #1E1E1E"></i>
                                                    <b>Телефон:</b> ${company.phone}
                                                </li>
                                            </#if>
                                            <#if company.esf?has_content>
                                                <li><i class="bi bi-server" style="color: #1E1E1E"></i> <b>ЭСФ
                                                        логин:</b> ${company.esf}
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
                                                <li><i class="bi bi-truck" style="color: #1E1E1E"></i> <b>ЭТТН
                                                        логин:</b> ${company.ettn}
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
            <nav aria-label="Page navigation example">
                <ul class="pagination justify-content-center mt-5">
                    <!-- Кнопка "Назад" -->
                    <li class="page-item <#if !deletedCompanies.hasPrevious()>disabled</#if>">
                        <a class="page-link" href="?page=${deletedCompanies.number - 1}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <!-- Список всех страниц -->
                    <#list 1..deletedCompanies.totalPages as i>
                        <li class="page-item <#if (i - 1) == deletedCompanies.number>active</#if>">
                            <a class="page-link" href="?page=${i - 1}">${i}</a>
                        </li>
                    </#list>

                    <!-- Кнопка "Вперед" -->
                    <li class="page-item <#if !deletedCompanies.hasNext()>disabled</#if>">
                        <a class="page-link" href="?page=${deletedCompanies.number + 1}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>

        <#else>
            <span class="text-center text-muted">Нет удаленных компаний</span>
        </#if>
    </div>

    <div id="users" class="tab-content">
        <table class="styled-table" id="users-table">
            <thead>
            <tr>
                <th>ФИО</th>
                <th>Логин</th>
                <th>Адрес эл. почты</th>
                <th>День рождения</th>
                <th>Дата регистрации</th>
                <th>Восстановить</th>
            </tr>
            </thead>
            <tbody>
            <#if deletedUsers?has_content>
                <#list deletedUsers as user>
                    <tr id="${user.id}-tr">
                        <td>${user.name} ${user.surname}</td>
                        <td>${user.login}</td>
                        <td>${user.email}</td>
                        <td>${user.birthday}</td>
                        <td>${user.registerDate}</td>
                        <td class="return-button-list-td">
                            <button class="btn btn-light btn-return-user-in-list" onclick="openModal(${user.id})"><i
                                        class="bi bi-person-fill-up fs-5" style="color: #1E1E1E"></i></button>
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
            <label for="roleSelect"><h2>Выберите роль</h2></label>
            <select id="roleSelect">
                <#list roles as role>
                    <option value="${role.id}">${role.roleName}</option>
                </#list>
            </select>
            <div class="d-flex justify-content-center">
                <button type="button" class="btn btn-success choose-role-btn" onclick="confirmRole()"><i
                            class="bi bi-check2 check-icon-choose-role"></i></button>
            </div>
        </div>
    </div>

    <div id="tasks" class="tab-content">
        <select id="filterDocumentType" class="form-control w-auto">
            <option value="">Все типы документов</option>
            <#list documentTypes as type>
                <option value="${type.name}">${type.name}</option>
            </#list>
        </select>
        <table id="tasksTable" class="styled-table">
            <thead>
            <tr>
                <th>Компания</th>
                <th>ИНН компании</th>
                <th>Тип документа</th>
                <th>Дата начала</th>
                <th>Дата окончания</th>
                <th>Сумма</th>
                <th>Файл</th>
                <th>Изменить статус</th>
            </tr>
            </thead>
            <tbody>
            <#if finishedTasks?has_content>
                <#list finishedTasks as task>
                    <tr data-task-id="${task.id}">
                        <td>${task.company.name}</td>
                        <td>${task.company.inn}</td>
                        <td>${task.documentTypeName}</td>
                        <td>${task.startDate}</td>
                        <td>${task.endDate}</td>
                        <td>${task.amount}</td>
                        <td>
                            <a href="/api/files/download/${task.filePath}">
                                скачать файл
                            </a>
                        </td>

                        <td>
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
</@layout.layout>

<script src="/js/archive.js"></script>