<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 ,maximum-scale=1.0,minimum-scale=1.0">
    <title>Список Компаний</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/company.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="/css/company/main.css">
</head>
<body>

<nav class="navbar navbar-expand-lg bg-body-tertiary">
    <div class="container-fluid">
        <a class="navbar-brand" href="/"><i class="bi bi-house-door"></i></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav me-auto mb-lg-0">
                <li class="nav-item">
                    <p class="nav-link active nav-com">Companies list</p>
                </li>
            </ul>
            <ul class="navbar-nav mx-auto">
                <li class="nav-item">
                    <p class="nav-link active">Компании</p>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item me-5">
                    <button type="button" class="btn btn-light plus-btn-over" id="sortButton" data-bs-toggle="collapse" data-bs-target="#sortSelect">
                        <i class="bi bi-filter plus-btn"></i>
                    </button>
                </li>
                <li class="nav-item collapse mt-2 me-5" id="sortSelect">
                    <#assign sort = sort! "actual">
                    <form id="filterForm" class="list-group-item list-group-item-action titleList" method="get"
                          action="/company/all?companyId=0&page=0&sort=${sort}">
                        <div class="form-group">
                            <select id="sort" name="sort" class="form-control" onchange="updateFilter()">
                                <option value="actual" <#if sort == "actual">selected</#if>>Актуальные Компании</option>
                                <option value="archive" <#if sort == "archive">selected</#if>>Удаленные Компании</option>
                            </select>
                        </div>
                    </form>
                </li>
                <li class="nav-item">
                    <#if canCreate>
                        <button type="button" class="btn btn-light plus-btn-over" id="createCompanyButton"
                                data-bs-toggle="modal" data-bs-target="#createCompanyModal">
                            <i class="bi bi-plus-circle plus-btn"></i>
                        </button>
                    </#if>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <#if _csrf??>
        <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
               value="${(_csrf.token)!'csrf-token'}"/>
    </#if>
    <div class="row">
        <div class="companies-sidebar-main">
            <div class="list-group">

                <label for="search" class="w-100 list-group-item titleList top-title custom-search">
                    <input type="text" class="w-100 search-input" id="search" placeholder="Название">
                </label>

                <div class="scroll-company" id="total">
                    <ul class="search">
                        <#list list as item>
                            <li class="choice-company list-group-item list-group-item-action <#if companyId == item.id>active</#if>">
                                <a href="/company/all?companyId=${item.id}&sort=${sort}"
                                >${item.name}</a>
                            </li>
                        </#list>
                    </ul>
                </div>
            </div>
        </div>

        <div class="companies-info-main companies-nav">
            <div class="forms-back-color">
                <div class="forms">
                    <#if company?? && company.id?has_content>

                    <div class="row">

                        <div class="h-company-info">
                            <h2 class="titleInfoCreate">
                                <span id="companyName" class="inline-block">${company.name!}</span>
                                <#if canEdit>
                                    <button id="editBtncompanyName" onclick="editText('companyName', ${company.id})"
                                            title="Редактировать" class="btn btn-link p-0">
                                        <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                    </button>
                                </#if>
                                <button onclick="copyText('companyName')" title="Скопировать" class="btn btn-link p-0">
                                    <i class="bi bi-copy icon-custom"></i>
                                </button>
                                <div class="company-name-edit">
                                    <input type="text" id="editInputcompanyName" class="form-control edit-input d-none"
                                           value="${company.name!}">
                                    <button id="cancelBtncompanyName" class="btn btn-light d-none"
                                            onclick="cancelEdit('companyName')">&#10005;
                                    </button>
                                    <button id="saveBtncompanyName" class="btn btn-light d-none"
                                            onclick="saveChanges('companyName', ${company.id})">&#10003;
                                    </button>
                                </div>
                            </h2>
                        </div>

                        <div class="company-info-buttons d-flex justify-content-end">
                            <#if canDelete>

                                <#if !company.deleted>

                                    <button type="button" class="btn  btn-custom-delete"
                                            data-bs-toggle="modal" data-bs-target="#deleteModal">
                                        <i class="bi bi-trash delete-icon fs-1" id="delete-user-icon"></i>
                                    </button>

                                    <div class="modal fade" id="deleteModal" tabindex="-1"
                                         aria-labelledby="deleteModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="deleteModalLabel">Подтверждение
                                                        удаления</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                            aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    Вы уверены, что хотите удалить эту компанию?
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Отмена
                                                    </button>
                                                    <form action="/company/delete" method="post" id="deleteForm">
                                                        <#if _csrf??>
                                                            <input type="hidden"
                                                                   name="${(_csrf.parameterName)!'csrf-param-name'}"
                                                                   value="${(_csrf.token)!'csrf-token'}"/>
                                                        </#if>
                                                        <input type="hidden" name="companyId" value="${company.id}">
                                                        <button type="submit" class="btn btn-danger"
                                                                onclick="clearSortFilter()">Удалить
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </#if>

                            </#if>

                            <#if canReturn>

                                <#if company.deleted>

                                    <button type="button" class="btn  btn-custom-delete"
                                            data-bs-toggle="modal" data-bs-target="#returnModal">
                                        <i class="bi bi-reply-all"></i>
                                    </button>

                                    <div class="modal fade" id="returnModal" tabindex="-1"
                                         aria-labelledby="returnModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="returnModalLabel">Подтверждение
                                                        восстановления</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                            aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body">
                                                    Вы уверены, что хотите восстановить эту компанию?
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Отмена
                                                    </button>
                                                    <form action="/company/return" method="post" id="returnForm">
                                                        <#if _csrf??>
                                                            <input type="hidden"
                                                                   name="${(_csrf.parameterName)!'csrf-param-name'}"
                                                                   value="${(_csrf.token)!'csrf-token'}"/>
                                                        </#if>
                                                        <input type="hidden" name="companyId" value="${company.id}">
                                                        <button type="submit" class="btn btn-danger"
                                                                onclick="clearSortFilter()">Востановить
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </#if>

                            </#if>
                        </div>

                    </div>

                        <div class="row">
                            <div class="company-required-info">
                                <ul class="list-group">
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ИНН:</span>
                                        <strong id="companyInn">${company.companyInn!}</strong>
                                        <#if canEdit>
                                            <button id="editBtncompanyInn"
                                                    onclick="editText('companyInn', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('companyInn')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputcompanyInn"
                                               class="form-control edit-input d-none"
                                               value="${company.companyInn!}">
                                        <button id="cancelBtncompanyInn" class="btn btn-light d-none"
                                                onclick="cancelEdit('companyInn')">&#10005;
                                        </button>
                                        <button id="saveBtncompanyInn" class="btn btn-light d-none"
                                                onclick="saveChanges('companyInn', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ИНН руководителя:</span>
                                        <strong id="directorInn">${company.directorInn!}</strong>
                                        <#if canEdit>
                                            <button id="editBtndirectorInn"
                                                    onclick="editText('directorInn', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('directorInn')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputdirectorInn"
                                               class="form-control edit-input d-none"
                                               value="${company.directorInn!}">
                                        <button id="cancelBtndirectorInn" class="btn btn-light d-none"
                                                onclick="cancelEdit('directorInn')">&#10005;
                                        </button>
                                        <button id="saveBtndirectorInn" class="btn btn-light d-none"
                                                onclick="saveChanges('directorInn', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Логин:</span>
                                        <strong id="login">${company.login!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnlogin" onclick="editText('login', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('login')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputlogin"
                                               class="form-control edit-input d-none"
                                               value="${company.login!}">
                                        <button id="cancelBtnlogin" class="btn btn-light d-none"
                                                onclick="cancelEdit('login')">&#10005;
                                        </button>
                                        <button id="saveBtnlogin" class="btn btn-light d-none"
                                                onclick="saveChanges('login', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Пароль:</span>
                                        <strong id="password"
                                              data-password="${company.password!}"><#list 1..(company.password!?length) as i>•</#list></strong>
                                        <#if canEdit>
                                            <button id="editBtnpassword" onclick="editText('password', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('password')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('password', this)" title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye icon-custom-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputpassword"
                                               class="form-control edit-input d-none "
                                               value="${company.password!}">
                                        <button id="cancelBtnpassword" class="btn btn-light d-none"
                                                onclick="cancelEdit('password')">&#10005;
                                        </button>
                                        <button id="saveBtnpassword" class="btn btn-light d-none"
                                                onclick="saveChanges('password', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ЭЦП:</span>
                                        <strong id="ecp">${company.ecp!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnecp" onclick="editText('ecp', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('ecp')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputecp"
                                               class="form-control edit-input d-none " value="${company.ecp!}">
                                        <button id="cancelBtnecp" class="btn btn-light d-none"
                                                onclick="cancelEdit('ecp')">&#10005;
                                        </button>
                                        <button id="saveBtnecp" class="btn btn-light d-none"
                                                onclick="saveChanges('ecp', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Salyk.kg логин:</span>
                                        <strong id="kabinetSalyk">${company.kabinetSalyk!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnkabinetSalyk"
                                                    onclick="editText('kabinetSalyk', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('kabinetSalyk')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkabinetSalyk"
                                               class="form-control edit-input d-none "
                                               value="${company.kabinetSalyk!}">
                                        <button id="cancelBtnkabinetSalyk" class="btn btn-light d-none"
                                                onclick="cancelEdit('kabinetSalyk')">&#10005;
                                        </button>
                                        <button id="saveBtnkabinetSalyk" class="btn btn-light d-none"
                                                onclick="saveChanges('kabinetSalyk', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Salyk.kg пароль:</span>
                                        <strong id="kabinetSalykPassword"
                                              data-password="${company.kabinetSalykPassword!}"><#list 1..(company.kabinetSalykPassword!?length) as i>•</#list></strong>
                                        <#if canEdit>
                                            <button id="editBtnkabinetSalykPassword"
                                                    onclick="editText('kabinetSalykPassword', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('kabinetSalykPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('kabinetSalykPassword', this)" title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye icon-custom-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkabinetSalykPassword"
                                               class="form-control edit-input d-none "
                                               value="${company.kabinetSalykPassword!}">
                                        <button id="cancelBtnkabinetSalykPassword" class="btn btn-light d-none"
                                                onclick="cancelEdit('kabinetSalykPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnkabinetSalykPassword" class="btn btn-light d-none"
                                                onclick="saveChanges('kabinetSalykPassword', ${company.id})">
                                            &#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Режим налогообложения:</span>
                                        <strong id="taxMode">${company.taxMode!}</strong>
                                        <#if canEdit>
                                            <button id="editBtntaxMode" onclick="editText('taxMode', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('taxMode')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputtaxMode"
                                               class="form-control edit-input d-none "
                                               value="${company.taxMode!}">
                                        <button id="cancelBtntaxMode" class="btn btn-light d-none"
                                                onclick="cancelEdit('taxMode')">&#10005;
                                        </button>
                                        <button id="saveBtntaxMode" class="btn btn-light d-none"
                                                onclick="saveChanges('taxMode', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ОПФ:</span>
                                        <strong id="opf">${company.opf!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnopf" onclick="editText('opf', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('opf')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputopf"
                                               class="form-control edit-input d-none " value="${company.opf!}">
                                        <button id="cancelBtnopf" class="btn btn-light d-none"
                                                onclick="cancelEdit('opf')">&#10005;
                                        </button>
                                        <button id="saveBtnopf" class="btn btn-light d-none"
                                                onclick="saveChanges('opf', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Район ГНС:</span>
                                        <strong id="districtGns">${company.districtGns!}</strong>
                                        <#if canEdit>
                                            <button id="editBtndistrictGns"
                                                    onclick="editText('districtGns', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('districtGns')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputdistrictGns"
                                               class="form-control edit-input d-none "
                                               value="${company.districtGns!}">
                                        <button id="cancelBtndistrictGns" class="btn btn-light d-none"
                                                onclick="cancelEdit('districtGns')">&#10005;
                                        </button>
                                        <button id="saveBtndistrictGns" class="btn btn-light d-none"
                                                onclick="saveChanges('districtGns', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Номер социального фонда:</span>
                                        <strong id="socfundNumber">${company.socfundNumber!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnsocfundNumber"
                                                    onclick="editText('socfundNumber', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('socfundNumber')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputsocfundNumber"
                                               class="form-control edit-input d-none "
                                               value="${company.socfundNumber!}">
                                        <button id="cancelBtnsocfundNumber" class="btn btn-light d-none"
                                                onclick="cancelEdit('socfundNumber')">&#10005;
                                        </button>
                                        <button id="saveBtnsocfundNumber" class="btn btn-light d-none"
                                                onclick="saveChanges('socfundNumber', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Регистрационный номер МЮ:</span>
                                        <strong id="registrationNumberMj">${company.registrationNumberMj!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnregistrationNumberMj"
                                                    onclick="editText('registrationNumberMj', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('registrationNumberMj')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputregistrationNumberMj"
                                               class="form-control edit-input d-none "
                                               value="${company.registrationNumberMj!}">
                                        <button id="cancelBtnregistrationNumberMj" class="btn btn-light d-none"
                                                onclick="cancelEdit('registrationNumberMj')">&#10005;
                                        </button>
                                        <button id="saveBtnregistrationNumberMj" class="btn btn-light d-none"
                                                onclick="saveChanges('registrationNumberMj', ${company.id})">
                                            &#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ОКПО:</span>
                                        <strong id="okpo">${company.okpo!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnokpo" onclick="editText('okpo', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('okpo')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputokpo"
                                               class="form-control edit-input d-none " value="${company.okpo!}">
                                        <button id="cancelBtnokpo" class="btn btn-light d-none"
                                                onclick="cancelEdit('okpo')">&#10005;
                                        </button>
                                        <button id="saveBtnokpo" class="btn btn-light d-none"
                                                onclick="saveChanges('okpo', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ФИО руководителя:</span>
                                        <strong id="director">${company.director!}</strong>
                                        <#if canEdit>
                                            <button id="editBtndirector" onclick="editText('director', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('director')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputdirector"
                                               class="form-control edit-input d-none "
                                               value="${company.director!}">
                                        <button id="cancelBtndirector" class="btn btn-light d-none"
                                                onclick="cancelEdit('director')">&#10005;
                                        </button>
                                        <button id="saveBtndirector" class="btn btn-light d-none"
                                                onclick="saveChanges('director', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>КЭД:</span>
                                        <strong id="ked">${company.ked!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnked" onclick="editText('ked', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('ked')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputked"
                                               class="form-control edit-input d-none " value="${company.ked!}">
                                        <button id="cancelBtnked" class="btn btn-light d-none"
                                                onclick="cancelEdit('ked')">&#10005;
                                        </button>
                                        <button id="saveBtnked" class="btn btn-light d-none"
                                                onclick="saveChanges('ked', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            <div class="company-not-required-info">
                                <ul class="list-group">
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Почта:</span> <strong id="email">${company.email!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnemail" onclick="editText('email', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('email')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputemail"
                                               class="form-control edit-input d-none "
                                               value="${company.email!}">
                                        <button id="cancelBtnemail" class="btn btn-light d-none"
                                                onclick="cancelEdit('email')">&#10005;
                                        </button>
                                        <button id="saveBtnemail" class="btn btn-light d-none"
                                                onclick="saveChanges('email', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Пароль от почты:</span> <strong id="emailPassword"
                                                                                data-password="${company.emailPassword!}"><#if company.emailPassword!?length == 0>
                                            <#else>
                                                <#list 1..(company.emailPassword!?length) as i>•</#list>
                                            </#if></strong>
                                        <#if canEdit>
                                            <button id="editBtnemailPassword"
                                                    onclick="editText('emailPassword', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('emailPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('emailPassword', this)" title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye icon-custom-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputemailPassword"
                                               class="form-control edit-input d-none "
                                               value="${company.emailPassword!}">
                                        <button id="cancelBtnemailPassword" class="btn btn-light d-none"
                                                onclick="cancelEdit('emailPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnemailPassword" class="btn btn-light d-none"
                                                onclick="saveChanges('emailPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>Телефон:</span> <strong id="phone">${company.phone!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnphone" onclick="editText('phone', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('phone')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputphone"
                                               class="form-control edit-input d-none "
                                               value="${company.phone!}">
                                        <button id="cancelBtnphone" class="btn btn-light d-none"
                                                onclick="cancelEdit('phone')">&#10005;
                                        </button>
                                        <button id="saveBtnphone" class="btn btn-light d-none"
                                                onclick="saveChanges('phone', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ЭСФ логин:</span> <strong id="esf">${company.esf!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnesf" onclick="editText('esf', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('esf')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputesf"
                                               class="form-control edit-input d-none " value="${company.esf!}">
                                        <button id="cancelBtnesf" class="btn btn-light d-none"
                                                onclick="cancelEdit('esf')">&#10005;
                                        </button>
                                        <button id="saveBtnesf" class="btn btn-light d-none"
                                                onclick="saveChanges('esf', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ЭСФ пароль:</span> <strong id="esfPassword"
                                                                           data-password="${company.esfPassword!}"><#if company.esfPassword!?length == 0>
                                            <#else>
                                                <#list 1..(company.esfPassword!?length) as i>•</#list>
                                            </#if></strong>
                                        <#if canEdit>
                                            <button id="editBtnesfPassword"
                                                    onclick="editText('esfPassword', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('esfPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('esfPassword', this)" title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye icon-custom-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputesfPassword"
                                               class="form-control edit-input d-none "
                                               value="${company.esfPassword!}">
                                        <button id="cancelBtnesfPassword" class="btn btn-light d-none"
                                                onclick="cancelEdit('esfPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnesfPassword" class="btn btn-light d-none"
                                                onclick="saveChanges('esfPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ККМ логин:</span> <strong id="kkm">${company.kkm!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnkkm" onclick="editText('kkm', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('kkm')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkkm"
                                               class="form-control edit-input d-none " value="${company.kkm!}">
                                        <button id="cancelBtnkkm" class="btn btn-light d-none"
                                                onclick="cancelEdit('kkm')">&#10005;
                                        </button>
                                        <button id="saveBtnkkm" class="btn btn-light d-none"
                                                onclick="saveChanges('kkm', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ККМ пароль:</span> <strong id="kkmPassword"
                                                                           data-password="${company.kkmPassword!}"> <#if company.kkmPassword!?length == 0>
                                            <#else>
                                                <#list 1..(company.kkmPassword!?length) as i>•</#list>
                                            </#if></strong>
                                        <#if canEdit>
                                            <button id="editBtnkkmPassword"
                                                    onclick="editText('kkmPassword', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('kkmPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('kkmPassword', this)" title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye icon-custom-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkkmPassword"
                                               class="form-control edit-input d-none "
                                               value="${company.kkmPassword!}">
                                        <button id="cancelBtnkkmPassword" class="btn btn-light d-none"
                                                onclick="cancelEdit('kkmPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnkkmPassword" class="btn btn-light d-none"
                                                onclick="saveChanges('kkmPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>1С Фреш логин:</span>
                                        <strong id="fresh1c">${company.fresh1c!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnfresh1c" onclick="editText('fresh1c', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('fresh1c')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputfresh1c"
                                               class="form-control edit-input d-none "
                                               value="${company.fresh1c!}">
                                        <button id="cancelBtnfresh1c" class="btn btn-light d-none"
                                                onclick="cancelEdit('fresh1c')">&#10005;
                                        </button>
                                        <button id="saveBtnfresh1c" class="btn btn-light d-none"
                                                onclick="saveChanges('fresh1c', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>1С Фреш пароль:</span> <strong id="fresh1cPassword"
                                                                               data-password="${company.fresh1cPassword!}"><#if company.fresh1cPassword!?length == 0>
                                            <#else>
                                                <#list 1..(company.fresh1cPassword!?length) as i>•</#list>
                                            </#if></strong>
                                        <#if canEdit>
                                            <button id="editBtnfresh1cPassword"
                                                    onclick="editText('fresh1cPassword', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('fresh1cPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('fresh1cPassword', this)" title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye icon-custom-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputfresh1cPassword"
                                               class="form-control edit-input d-none "
                                               value="${company.fresh1cPassword!}">
                                        <button id="cancelBtnfresh1cPassword" class="btn btn-light d-none"
                                                onclick="cancelEdit('fresh1cPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnfresh1cPassword" class="btn btn-light d-none"
                                                onclick="saveChanges('fresh1cPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ЭТТН логин:</span>
                                        <strong id="ettn">${company.ettn!}</strong>
                                        <#if canEdit>
                                            <button id="editBtnettn" onclick="editText('ettn', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('ettn')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputettn"
                                               class="form-control edit-input d-none " value="${company.ettn!}">
                                        <button id="cancelBtnettn" class="btn btn-light d-none"
                                                onclick="cancelEdit('ettn')">&#10005;
                                        </button>
                                        <button id="saveBtnettn" class="btn btn-light d-none"
                                                onclick="saveChanges('ettn', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line company-info">
                                        <span>ЭТТН пароль:</span>
                                        <strong id="ettnPassword"
                                              data-password="${company.ettnPassword!}"><#if company.ettnPassword!?length == 0>
                                            <#else>
                                                <#list 1..(company.ettnPassword!?length) as i>•</#list>
                                            </#if></strong>
                                        <#if canEdit>
                                            <button id="editBtnettnPassword"
                                                    onclick="editText('ettnPassword', ${company.id})"
                                                    title="Редактировать" class="btn btn-link p-0">
                                                <i class="bi bi-pencil icon-custom-pencil" style="color: black;"></i>
                                            </button>
                                        </#if>
                                        <button onclick="copyText('ettnPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-copy icon-custom"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('ettnPassword', this)" title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye icon-custom-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputettnPassword"
                                               class="form-control edit-input d-none "
                                               value="${company.ettnPassword!}">
                                        <button id="cancelBtnettnPassword" class="btn btn-light d-none"
                                                onclick="cancelEdit('ettnPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnettnPassword" class="btn btn-light d-none"
                                                onclick="saveChanges('ettnPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>

                                    <li class="list-group-item list-none-line company-info">
                                        <#if company.deleted>
                                            <span>Состояние:</span> <strong> Удаленная компания</strong>
                                        <#else>
                                            <span>Состояние:</span> <strong> Актуальная компания</strong>
                                        </#if>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </#if>

                    <div class="modal fade" id="createCompanyModal" tabindex="-1"
                         aria-labelledby="createCompanyModalLabel" aria-hidden="true">
                        <div class="modal-dialog custom-modal-width col-md-10">
                            <div class="modal-content">

                                <div class="modal-header modal-header-create">
                                    <h5 class="modal-title modal-title-create" id="createCompanyModalLabel">Создание Компании</h5>
                                    <button type="button" class="btn-close btn-close-create" id="closeModalButton" aria-label="Close"
                                            onclick="closeModalCreate()"></button>
                                </div>

                                <div class="modal-body">

                                    <form action="/company/create" method="post" onsubmit="submitForm(event)">
                                        <#if _csrf??>
                                            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                                   value="${(_csrf.token)!'csrf-token'}"/>
                                        </#if>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <fieldset class="p-4 mb-4">
                                                    <div class="form-group row">
                                                        <label for="name" class="col-md-4 col-form-label">Название
                                                            компании:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="name" name="name"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="name-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="companyInn"
                                                               class="col-md-4 col-form-label">ИНН:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="companyInn" name="companyInn"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="companyInn-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="directorInn" class="col-md-4 col-form-label">ИНН
                                                            руководителя:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="directorInn" name="directorInn"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="directorInn-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="login"
                                                               class="col-md-4 col-form-label">Логин:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="login" name="login"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="login-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="password"
                                                               class="col-md-4 col-form-label">Пароль:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="password" name="password"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="password-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="ecp" class="col-md-4 col-form-label">ЭЦП:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="ecp" name="ecp" class="form-control"
                                                                   required>
                                                            <span class="company-create-errors" id="ecp-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="kabinetSalyk" class="col-md-4 col-form-label">Salyk.kg
                                                            логин:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="kabinetSalyk" name="kabinetSalyk"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="kabinetSalyk-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="kabinetSalykPassword"
                                                               class="col-md-4 col-form-label">Salyk.kg пароль:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="kabinetSalykPassword"
                                                                   name="kabinetSalykPassword" class="form-control"
                                                                   required>
                                                            <span class="company-create-errors" id="kabinetSalykPassword-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="taxMode" class="col-md-4 col-form-label">Режим
                                                            налогооблажения:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="taxMode" name="taxMode"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="taxMode-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="opf" class="col-md-4 col-form-label">ОПФ:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="opf" name="opf" class="form-control"
                                                                   required>
                                                            <span class="company-create-errors" id="opf-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="districtGns" class="col-md-4 col-form-label">Район
                                                            ГНС:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="districtGns" name="districtGns"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="districtGns-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="socfundNumber" class="col-md-4 col-form-label">Номер
                                                            соцфонда:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="socfundNumber" name="socfundNumber"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="socfundNumber-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="registrationNumberMj"
                                                               class="col-md-4 col-form-label">Регистрационный номер
                                                            МЮ:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="registrationNumberMj"
                                                                   name="registrationNumberMj" class="form-control"
                                                                   required>
                                                            <span class="company-create-errors" id="registrationNumberMj-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="okpo" class="col-md-4 col-form-label">ОКПО:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="okpo" name="okpo"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="okpo-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="director" class="col-md-4 col-form-label">ФИО
                                                            руководителя:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="director" name="director"
                                                                   class="form-control" required>
                                                            <span class="company-create-errors" id="director-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="ked" class="col-md-4 col-form-label">КЭД:<span class="required-asterisk">*</span></label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="ked" name="ked" class="form-control"
                                                                   required>
                                                            <span class="company-create-errors" id="ked-error"></span>
                                                        </div>
                                                    </div>
                                                </fieldset>
                                            </div>

                                            <div class="col-md-6">
                                                <fieldset class="p-4 mb-4">
                                                    <div class="form-group row">
                                                        <label for="email"
                                                               class="col-md-4 col-form-label">Почта:</label>
                                                        <div class="col-md-8">
                                                            <input type="email" id="email" name="email"
                                                                   class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="emailPassword" class="col-md-4 col-form-label">Пароль
                                                            от почты:</label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="emailPassword"
                                                                   name="emailPassword" class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="phone"
                                                               class="col-md-4 col-form-label">Телефон:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="phone" name="phone"
                                                                   class="form-control">
                                                            <span class="company-create-errors" id="phone-error"></span>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="esf" class="col-md-4 col-form-label">ЭСФ
                                                            логин:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="esf" name="esf" class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="esfPassword" class="col-md-4 col-form-label">ЭСФ
                                                            пароль:</label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="esfPassword" name="esfPassword"
                                                                   class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="kkm" class="col-md-4 col-form-label">ККМ
                                                            логин:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="kkm" name="kkm" class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="kkmPassword" class="col-md-4 col-form-label">ККМ
                                                            пароль:</label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="kkmPassword" name="kkmPassword"
                                                                   class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="fresh1c" class="col-md-4 col-form-label">1С Фреш
                                                            логин:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="fresh1c" name="fresh1c"
                                                                   class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="fresh1cPassword" class="col-md-4 col-form-label">1С
                                                            Фреш пароль:</label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="fresh1cPassword"
                                                                   name="fresh1cPassword" class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="ettn" class="col-md-4 col-form-label">ЭТТН
                                                            логин:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="ettn" name="ettn"
                                                                   class="form-control">
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="ettnPassword" class="col-md-4 col-form-label">ЭТТН
                                                            пароль:</label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="ettnPassword" name="ettnPassword"
                                                                   class="form-control">
                                                        </div>
                                                    </div>

                                                    <div class="form-group row">
                                                        <label for="reportFrequency" class="col-md-4 col-form-label">Выберите частоту отчета НСП:</label>
                                                        <div class="col-md-8">
                                                            <select name="reportFrequency" id="reportFrequency" class="form-control">
                                                                <option value="" disabled selected>Выбор частоты</option>
                                                                <option value="MONTHLY">Ежемесячно</option>
                                                                <option value="QUARTERLY">Ежеквартально</option>
                                                            </select>
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


                </div>
            </div>
        </div>

    </div>
</div>
<input type="hidden" id="openModal" value="${openModal?string('true', 'false')}">
</body>
</html>
