<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Список Компаний</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/static/js/company/all.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="/static/css/company/main.css">
</head>
<body>
<header>
    <div class="container">
        <nav class="navbar navbar-expand-lg bg-body-tertiary">
            <div class="container-fluid">
                <a class="navbar-brand" href="#"><i class="bi bi-house-door"></i></a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item">
                            <a class="nav-link active" aria-current="page" href="#">Companies list</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav mx-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="#">Компании</a>
                        </li>
                    </ul>
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <button class="btn btn-light plus-btn-over" id="createCompanyButton" onclick="toggleCreateForm()"><i class="bi bi-plus-circle plus-btn"></i></button>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>
    </div>
</header>
<div class="container">
    <#if _csrf??>
        <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
               value="${(_csrf.token)!'csrf-token'}"/>
    </#if>
    <div class="row">
        <div class="col-md-3">
            <div class="list-group">
                <#if 0 < currentPage>
                    <a href="/company/all/?companyId=${companyId}&page=${currentPage - 1}&sort=${sort}" class="btn btn-light arrow-btn">
                        <i class="bi bi-arrow-up-circle arrow"></i>
                    </a>
                </#if>

                <#assign sort = sort! "actual">
                <p class="list-group-item list-group-item-action titleList">Название</p>
                <form id="filterForm" class="list-group-item list-group-item-action titleList"  method="get" action="/company/all/?companyId=0&page=0&sort=${sort}">
                    <div class="form-group">
                        <label for="sort">Выберите список:</label>
                        <select id="sort" name="sort" class="form-control" onchange="updateFilter()">
                            <option value="actual" <#if sort == "actual">selected</#if>>Актуальные Компании</option>
                            <option value="archive" <#if sort == "archive">selected</#if>>Удаленные Компании</option>
                        </select>
                    </div>
                </form>

                <#list list as item>
                    <a href="/company/all/?companyId=${item.id}&page=${currentPage}&sort=${sort}" class="list-group-item list-group-item-action <#if companyId == item.id>active</#if>">${item.name}</a>
                </#list>

                <#if currentPage < totalPages - 1>
                    <a href="/company/all/?companyId=${companyId}&page=${currentPage + 1}&sort=${sort}" class="btn btn-light arrow-btn">
                        <i class="bi bi-arrow-down-circle arrow"></i>
                    </a>
                </#if>
            </div>
        </div>


        <div class="col-md-9">
            <#if company?? && company.id?has_content>

            <div id="companyInfo" style="display:block;">
                <h2 class="text-center titleInfoCreate">Наименование компании: ${company.name!}</h2>
                <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editModalLabel">Редактировать</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
                            </div>
                            <div class="modal-body">
                                <label for="editInput" class="form-label">Новое значение:</label>
                                <input type="text" id="editInput" class="form-control">
                                <input type="hidden" id="editFieldId">
                                <input type="hidden" id="editCompanyId">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                                <button type="button" class="btn btn-primary" onclick="saveChanges()">Сохранить</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <strong>ИНН:</strong> <span id="companyInn">${company.companyInn!}</span>
                                <button onclick="copyText('companyInn')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('companyInn', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ИНН руководителя:</strong> <span id="directorInn">${company.directorInn!}</span>
                                <button onclick="copyText('directorInn')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('directorInn', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Логин:</strong> <span id="login">${company.login!}</span>
                                <button onclick="copyText('login')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('login', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Пароль:</strong> <span id="password" data-password="${company.password!}">••••••</span>
                                <button onclick="copyText('password')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('password', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('password')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭЦП:</strong> <span id="ecp">${company.ecp!}</span>
                                <button onclick="copyText('ecp')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ecp', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Salyk.kg логин:</strong> <span id="kabinetSalyk">${company.kabinetSalyk!}</span>
                                <button onclick="copyText('kabinetSalyk')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kabinetSalyk', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Salyk.kg пароль:</strong> <span id="kabinetSalykPassword" data-password="${company.kabinetSalykPassword!}">••••••</span>
                                <button onclick="copyText('kabinetSalykPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kabinetSalykPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('kabinetSalykPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Режим налогообложения:</strong> <span id="taxMode">${company.taxMode!}</span>
                                <button onclick="copyText('taxMode')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('taxMode', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ОПФ:</strong> <span id="opf">${company.opf!}</span>
                                <button onclick="copyText('opf')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('opf', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Район ГНС:</strong> <span id="districtGns">${company.districtGns!}</span>
                                <button onclick="copyText('districtGns')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('districtGns', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Номер социального фонда:</strong> <span id="socfundNumber">${company.socfundNumber!}</span>
                                <button onclick="copyText('socfundNumber')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('socfundNumber', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Регистрационный номер МЮ:</strong> <span id="registrationNumberMj">${company.registrationNumberMj!}</span>
                                <button onclick="copyText('registrationNumberMj')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('registrationNumberMj', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ОКПО:</strong> <span id="okpo">${company.okpo!}</span>
                                <button onclick="copyText('okpo')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('okpo', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ФИО руководителя:</strong> <span id="director">${company.director!}</span>
                                <button onclick="copyText('director')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('director', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>КЭД:</strong> <span id="ked">${company.ked!}</span>
                                <button onclick="copyText('ked')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ked', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <strong>Почта:</strong> <span id="email">${company.email!}</span>
                                <button onclick="copyText('email')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('email', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Пароль от почты:</strong> <span id="emailPassword" data-password="${company.emailPassword!}">••••••</span>
                                <button onclick="copyText('emailPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('emailPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('emailPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>Телефон:</strong> <span id="phone">${company.phone!}</span>
                                <button onclick="copyText('phone')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('phone', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭСФ логин:</strong> <span id="esf">${company.esf!}</span>
                                <button onclick="copyText('esf')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('esf', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭСФ пароль:</strong> <span id="esfPassword" data-password="${company.esfPassword!}">••••••</span>
                                <button onclick="copyText('esfPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('esfPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('esfPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ККМ логин:</strong> <span id="kkm">${company.kkm!}</span>
                                <button onclick="copyText('kkm')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kkm', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ККМ пароль:</strong> <span id="kkmPassword" data-password="${company.kkmPassword!}">••••••</span>
                                <button onclick="copyText('kkmPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('kkmPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('kkmPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>1С Фреш логин:</strong> <span id="fresh1c">${company.fresh1c!}</span>
                                <button onclick="copyText('fresh1c')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('fresh1c', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>1С Фреш пароль:</strong> <span id="fresh1cPassword" data-password="${company.fresh1cPassword!}">••••••</span>
                                <button onclick="copyText('fresh1cPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('fresh1cPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('fresh1cPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭТТН логин:</strong> <span id="ettn">${company.ettn!}</span>
                                <button onclick="copyText('ettn')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ettn', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                            </li>
                            <li class="list-group-item">
                                <strong>ЭТТН пароль:</strong> <span id="ettnPassword" data-password="${company.ettnPassword!}">••••••</span>
                                <button onclick="copyText('ettnPassword')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-clipboard" style="color: black;"></i>
                                </button>
                                <button onclick="editText('ettnPassword', ${company.id})" title="Редактировать" class="btn btn-link p-0">
                                    <i class="bi bi-pencil" style="color: black;"></i>
                                </button>
                                <button onclick="togglePasswordVisibility('ettnPassword')" title="Увидеть" class="btn btn-link p-0">
                                    <i class="bi bi-eye" style="color: black;"></i>
                                </button>
                            </li>
                        </ul>
                    </div>
                    <#if isAdmin>



                        <#if company.deleted>
                            <button type="button" class="btn btn-danger btn-custom-delete" data-bs-toggle="modal" data-bs-target="#returnModal">
                                Восстановить Компанию
                            </button>

                            <div class="modal fade" id="returnModal" tabindex="-1" aria-labelledby="returnModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="returnModalLabel">Подтверждение восстановления</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            Вы уверены, что хотите восстановить эту компанию?
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                                            <form action="/company/return" method="post" id="returnForm">
                                                <#if _csrf??>
                                                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}" value="${(_csrf.token)!'csrf-token'}"/>
                                                </#if>
                                                <input type="hidden" name="companyId" value="${company.id}">
                                                <button type="submit" class="btn btn-danger">Востановить</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <#else>
                            <button type="button" class="btn btn-danger btn-custom-delete" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                Удалить Компанию
                            </button>

                            <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="deleteModalLabel">Подтверждение удаления</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            Вы уверены, что хотите удалить эту компанию?
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Отмена</button>
                                            <form action="/company/delete" method="post" id="deleteForm">
                                                <#if _csrf??>
                                                    <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}" value="${(_csrf.token)!'csrf-token'}"/>
                                                </#if>
                                                <input type="hidden" name="companyId" value="${company.id}">
                                                <button type="submit" class="btn btn-danger">Удалить</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </#if>
                    </#if>
                </div>
                <#else>
                    <p>Выберите компанию для отображения</p>
                </#if>
            </div>

            <div id="createCompanyForm" style="display:none;">
                <h1 class="text-center titleInfoCreate">Создание Компании</h1>
                <form action="/company/create" method="post" onsubmit="submitForm(event)">
                    <#if _csrf??>
                        <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                               value="${(_csrf.token)!'csrf-token'}"/>
                    </#if>
                    <div class="row">
                        <div class="col-md-6">
                            <fieldset class="border p-4 mb-4">
                                <div class="form-group row">
                                    <label for="name" class="col-sm-4 col-form-label">Название компании:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="name" name="name" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("name"))>
                                            <span class="text-danger">${errors.getFieldError("name").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="companyInn" class="col-sm-4 col-form-label">ИНН:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="companyInn" name="companyInn" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("inn"))>
                                            <span class="text-danger">${errors.getFieldError("inn").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="directorInn" class="col-sm-4 col-form-label">ИНН руководителя:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="directorInn" name="directorInn" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("directorInn"))>
                                            <span class="text-danger">${errors.getFieldError("directorInn").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="login" class="col-sm-4 col-form-label">Логин:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="login" name="login" class="form-control"  required>
                                        <#if (errors?has_content && errors.hasFieldErrors("login"))>
                                            <span class="text-danger">${errors.getFieldError("login").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="password" class="col-sm-4 col-form-label">Пароль:</label>
                                    <div class="col-sm-8">
                                        <input type="password" id="password" name="password" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("password"))>
                                            <span class="text-danger">${errors.getFieldError("password").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ecp" class="col-sm-4 col-form-label">ЭЦП:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="ecp" name="ecp" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("ecp"))>
                                            <span class="text-danger">${errors.getFieldError("ecp").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="kabinetSalyk" class="col-sm-4 col-form-label">Salyk.kg логин:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="kabinetSalyk" name="kabinetSalyk" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("kabinetSalyk"))>
                                            <span class="text-danger">${errors.getFieldError("kabinetSalyk").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="kabinetSalykPassword" class="col-sm-4 col-form-label">Salyk.kg пароль:</label>
                                    <div class="col-sm-8">
                                        <input type="password" id="kabinetSalykPassword" name="kabinetSalykPassword" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("kabinetSalykPassword"))>
                                            <span class="text-danger">${errors.getFieldError("kabinetSalykPassword").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="taxMode" class="col-sm-4 col-form-label">Режим налогооблажения:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="taxMode" name="taxMode" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("taxMode"))>
                                            <span class="text-danger">${errors.getFieldError("taxMode").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="opf" class="col-sm-4 col-form-label">ОПФ:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="opf" name="opf" class="form-control" required >
                                        <#if (errors?has_content && errors.hasFieldErrors("opf"))>
                                            <span class="text-danger">${errors.getFieldError("opf").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="districtGns" class="col-sm-4 col-form-label">Район ГНС:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="districtGns" name="districtGns" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("districtGns"))>
                                            <span class="text-danger">${errors.getFieldError("districtGns").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="socfundNumber" class="col-sm-4 col-form-label">Номер соцфонда:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="socfundNumber" name="socfundNumber" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("socfundNumber"))>
                                            <span class="text-danger">${errors.getFieldError("socfundNumber").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="registrationNumberMj" class="col-sm-4 col-form-label">Регистрационный номер МЮ:</label>
                                    <div class="col-sm-8">
                                        <input type="text" id="registrationNumberMj" name="registrationNumberMj" class="form-control" required >
                                        <#if (errors?has_content && errors.hasFieldErrors("registrationNumberMj"))>
                                            <span class="text-danger">${errors.getFieldError("registrationNumberMj").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="okpo" class="col-md-4 col-form-label">ОКПО:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="okpo" name="okpo" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("okpo"))>
                                            <span class="text-danger">${errors.getFieldError("okpo").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="director" class="col-md-4 col-form-label">ФИО руководителя:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="director" name="director" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("director"))>
                                            <span class="text-danger">${errors.getFieldError("director").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ked" class="col-md-4 col-form-label">КЭД:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="ked" name="ked" class="form-control" required>
                                        <#if (errors?has_content && errors.hasFieldErrors("ked"))>
                                            <span class="text-danger">${errors.getFieldError("ked").defaultMessage}</span>
                                        </#if>
                                    </div>
                                </div>
                            </fieldset>
                        </div>

                        <div class="col-md-6">
                            <fieldset class="border p-4 mb-4">
                                <div class="form-group row">
                                    <label for="email" class="col-md-4 col-form-label">Почта:</label>
                                    <div class="col-md-8">
                                        <input type="email" id="email" name="email" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="emailPassword" class="col-md-4 col-form-label">Пароль от почты:</label>
                                    <div class="col-md-8">
                                        <input type="password" id="emailPassword" name="emailPassword" class="form-control" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="phone" class="col-md-4 col-form-label">Телефон:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="phone" name="phone" class="form-control" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="esf" class="col-md-4 col-form-label">ЭСФ логин:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="esf" name="esf" class="form-control" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="esfPassword" class="col-md-4 col-form-label">ЭСФ пароль:</label>
                                    <div class="col-md-8">
                                        <input type="password" id="esfPassword" name="esfPassword" class="form-control" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="kkm" class="col-md-4 col-form-label">ККМ логин:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="kkm" name="kkm" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="kkmPassword" class="col-md-4 col-form-label">ККМ пароль:</label>
                                    <div class="col-md-8">
                                        <input type="password" id="kkmPassword" name="kkmPassword" class="form-control" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="fresh1c" class="col-md-4 col-form-label">1С Фреш логин:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="fresh1c" name="fresh1c" class="form-control" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="fresh1cPassword" class="col-md-4 col-form-label">1С Фреш пароль:</label>
                                    <div class="col-md-8">
                                        <input type="password" id="fresh1cPassword" name="fresh1cPassword" class="form-control">
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ettn" class="col-md-4 col-form-label">ЭТТН логин:</label>
                                    <div class="col-md-8">
                                        <input type="text" id="ettn" name="ettn" class="form-control" >
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ettnPassword" class="col-md-4 col-form-label">ЭТТН пароль:</label>
                                    <div class="col-md-8">
                                        <input type="password" id="ettnPassword" name="ettnPassword" class="form-control">
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                    </div>
                    <div class="d-flex justify-content-center align-items-center">
                        <button type="submit" class="btn btn-success submit-btn">
                            <i class="bi bi-check2 check-icon"></i>
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>
</body>
</html>
