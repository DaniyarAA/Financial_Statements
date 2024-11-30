<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0 ,maximum-scale=1.0,minimum-scale=1.0">
    <title>Список Компаний</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/company.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
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
                <li class="nav-item">
                    <button type="button" class="btn btn-light plus-btn-over" id="createCompanyButton"
                            data-bs-toggle="modal" data-bs-target="#createCompanyModal">
                        <i class="bi bi-plus-circle plus-btn"></i>
                    </button>
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
        <div class="col-md-2 col-sm-3">
            <div class="list-group">
                <div>
                    <label for="search" class="w-100">
                        <input type="text" class="w-100" id="search" placeholder="Поиск...">
                    </label>
                </div>

                <#assign sort = sort! "actual">
                <form id="filterForm" class="list-group-item list-group-item-action titleList" method="get"
                      action="/company/all?companyId=0&page=0&sort=${sort}">
                    <div class="form-group">
                        <label for="sort">Выберите список:</label>
                        <select id="sort" name="sort" class="form-control" onchange="updateFilter()">
                            <option value="actual" <#if sort == "actual">selected</#if>>Актуальные Компании</option>
                            <option value="archive" <#if sort == "archive">selected</#if>>Удаленные Компании</option>
                        </select>
                    </div>
                </form>

                <p class="list-group-item list-group-item-action titleList">Название</p>
                <div id="total" style="overflow-y: scroll; max-height: 600px;">
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

        <div class="col-md-10 col-sm-9 companies-nav">
            <div class="forms-back-color">
                <div class="forms">
                    <#if company?? && company.id?has_content>

                        <h2 class="text-center titleInfoCreate">
                            Наименование компании:
                            <span id="companyName" class="inline-block">${company.name!}</span>
                            <button onclick="copyText('companyName')" title="Скопировать" class="btn btn-link p-0">
                                <i class="bi bi-clipboard" style="color: black;"></i>
                            </button>
                            <button id="editBtncompanyName" onclick="editText('companyName', ${company.id})"
                                    title="Редактировать" class="btn btn-link p-0">
                                <i class="bi bi-pencil" style="color: black;"></i>
                            </button>
                            <div class="company-name-edit">
                            <input type="text" id="editInputcompanyName" class="form-control edit-input d-none fs-5"
                                   value="${company.name!}">
                            <button id="cancelBtncompanyName" class="btn btn-danger d-none"
                                    onclick="cancelEdit('companyName')">&#10005;
                            </button>
                            <button id="saveBtncompanyName" class="btn btn-success d-none"
                                    onclick="saveChanges('companyName', ${company.id})">&#10003;
                            </button>
                            </div>
                        </h2>
                        <div class="row">
                            <div class="col-md-6">
                                <ul class="list-group">
                                    <li class="list-group-item list-none-line">
                                        <strong>ИНН:</strong>
                                        <span id="companyInn">${company.companyInn!}</span>
                                        <button onclick="copyText('companyInn')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtncompanyInn"
                                                onclick="editText('companyInn', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputcompanyInn"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.companyInn!}">
                                        <button id="cancelBtncompanyInn" class="btn btn-danger d-none"
                                                onclick="cancelEdit('companyInn')">&#10005;
                                        </button>
                                        <button id="saveBtncompanyInn" class="btn btn-success d-none"
                                                onclick="saveChanges('companyInn', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ИНН руководителя:</strong>
                                        <span id="directorInn">${company.directorInn!}</span>
                                        <button onclick="copyText('directorInn')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtndirectorInn"
                                                onclick="editText('directorInn', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputdirectorInn"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.directorInn!}">
                                        <button id="cancelBtndirectorInn" class="btn btn-danger d-none"
                                                onclick="cancelEdit('directorInn')">&#10005;
                                        </button>
                                        <button id="saveBtndirectorInn" class="btn btn-success d-none"
                                                onclick="saveChanges('directorInn', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Логин:</strong>
                                        <span id="login">${company.login!}</span>
                                        <button onclick="copyText('login')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnlogin" onclick="editText('login', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputlogin"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.login!}">
                                        <button id="cancelBtnlogin" class="btn btn-danger d-none"
                                                onclick="cancelEdit('login')">&#10005;
                                        </button>
                                        <button id="saveBtnlogin" class="btn btn-success d-none"
                                                onclick="saveChanges('login', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Пароль:</strong>
                                        <span id="password"
                                              data-password="${company.password!}"><#list 1..(company.password!?length) as i>•</#list></span>
                                        <button onclick="copyText('password')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnpassword" onclick="editText('password', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('password')" title="Увидеть"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputpassword"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.password!}">
                                        <button id="cancelBtnpassword" class="btn btn-danger d-none"
                                                onclick="cancelEdit('password')">&#10005;
                                        </button>
                                        <button id="saveBtnpassword" class="btn btn-success d-none"
                                                onclick="saveChanges('password', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ЭЦП:</strong>
                                        <span id="ecp">${company.ecp!}</span>
                                        <button onclick="copyText('ecp')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnecp" onclick="editText('ecp', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputecp"
                                               class="form-control edit-input d-none fs-5" value="${company.ecp!}">
                                        <button id="cancelBtnecp" class="btn btn-danger d-none"
                                                onclick="cancelEdit('ecp')">&#10005;
                                        </button>
                                        <button id="saveBtnecp" class="btn btn-success d-none"
                                                onclick="saveChanges('ecp', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Salyk.kg логин:</strong>
                                        <span id="kabinetSalyk">${company.kabinetSalyk!}</span>
                                        <button onclick="copyText('kabinetSalyk')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnkabinetSalyk"
                                                onclick="editText('kabinetSalyk', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkabinetSalyk"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.kabinetSalyk!}">
                                        <button id="cancelBtnkabinetSalyk" class="btn btn-danger d-none"
                                                onclick="cancelEdit('kabinetSalyk')">&#10005;
                                        </button>
                                        <button id="saveBtnkabinetSalyk" class="btn btn-success d-none"
                                                onclick="saveChanges('kabinetSalyk', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Salyk.kg пароль:</strong>
                                        <span id="kabinetSalykPassword"
                                              data-password="${company.kabinetSalykPassword!}"><#list 1..(company.kabinetSalykPassword!?length) as i>•</#list></span>
                                        <button onclick="copyText('kabinetSalykPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnkabinetSalykPassword"
                                                onclick="editText('kabinetSalykPassword', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('kabinetSalykPassword')"
                                                title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkabinetSalykPassword"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.kabinetSalykPassword!}">
                                        <button id="cancelBtnkabinetSalykPassword" class="btn btn-danger d-none"
                                                onclick="cancelEdit('kabinetSalykPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnkabinetSalykPassword" class="btn btn-success d-none"
                                                onclick="saveChanges('kabinetSalykPassword', ${company.id})">
                                            &#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Режим налогообложения:</strong>
                                        <span id="taxMode">${company.taxMode!}</span>
                                        <button onclick="copyText('taxMode')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtntaxMode" onclick="editText('taxMode', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputtaxMode"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.taxMode!}">
                                        <button id="cancelBtntaxMode" class="btn btn-danger d-none"
                                                onclick="cancelEdit('taxMode')">&#10005;
                                        </button>
                                        <button id="saveBtntaxMode" class="btn btn-success d-none"
                                                onclick="saveChanges('taxMode', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ОПФ:</strong>
                                        <span id="opf">${company.opf!}</span>
                                        <button onclick="copyText('opf')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnopf" onclick="editText('opf', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputopf"
                                               class="form-control edit-input d-none fs-5" value="${company.opf!}">
                                        <button id="cancelBtnopf" class="btn btn-danger d-none"
                                                onclick="cancelEdit('opf')">&#10005;
                                        </button>
                                        <button id="saveBtnopf" class="btn btn-success d-none"
                                                onclick="saveChanges('opf', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Район ГНС:</strong>
                                        <span id="districtGns">${company.districtGns!}</span>
                                        <button onclick="copyText('districtGns')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtndistrictGns"
                                                onclick="editText('districtGns', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputdistrictGns"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.districtGns!}">
                                        <button id="cancelBtndistrictGns" class="btn btn-danger d-none"
                                                onclick="cancelEdit('districtGns')">&#10005;
                                        </button>
                                        <button id="saveBtndistrictGns" class="btn btn-success d-none"
                                                onclick="saveChanges('districtGns', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Номер социального фонда:</strong>
                                        <span id="socfundNumber">${company.socfundNumber!}</span>
                                        <button onclick="copyText('socfundNumber')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnsocfundNumber"
                                                onclick="editText('socfundNumber', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputsocfundNumber"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.socfundNumber!}">
                                        <button id="cancelBtnsocfundNumber" class="btn btn-danger d-none"
                                                onclick="cancelEdit('socfundNumber')">&#10005;
                                        </button>
                                        <button id="saveBtnsocfundNumber" class="btn btn-success d-none"
                                                onclick="saveChanges('socfundNumber', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Регистрационный номер МЮ:</strong>
                                        <span id="registrationNumberMj">${company.registrationNumberMj!}</span>
                                        <button onclick="copyText('registrationNumberMj')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnregistrationNumberMj"
                                                onclick="editText('registrationNumberMj', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputregistrationNumberMj"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.registrationNumberMj!}">
                                        <button id="cancelBtnregistrationNumberMj" class="btn btn-danger d-none"
                                                onclick="cancelEdit('registrationNumberMj')">&#10005;
                                        </button>
                                        <button id="saveBtnregistrationNumberMj" class="btn btn-success d-none"
                                                onclick="saveChanges('registrationNumberMj', ${company.id})">
                                            &#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ОКПО:</strong>
                                        <span id="okpo">${company.okpo!}</span>
                                        <button onclick="copyText('okpo')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnokpo" onclick="editText('okpo', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputokpo"
                                               class="form-control edit-input d-none fs-5" value="${company.okpo!}">
                                        <button id="cancelBtnokpo" class="btn btn-danger d-none"
                                                onclick="cancelEdit('okpo')">&#10005;
                                        </button>
                                        <button id="saveBtnokpo" class="btn btn-success d-none"
                                                onclick="saveChanges('okpo', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ФИО руководителя:</strong>
                                        <span id="director">${company.director!}</span>
                                        <button onclick="copyText('director')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtndirector" onclick="editText('director', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputdirector"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.director!}">
                                        <button id="cancelBtndirector" class="btn btn-danger d-none"
                                                onclick="cancelEdit('director')">&#10005;
                                        </button>
                                        <button id="saveBtndirector" class="btn btn-success d-none"
                                                onclick="saveChanges('director', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>КЭД:</strong>
                                        <span id="ked">${company.ked!}</span>
                                        <button onclick="copyText('ked')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnked" onclick="editText('ked', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputked"
                                               class="form-control edit-input d-none fs-5" value="${company.ked!}">
                                        <button id="cancelBtnked" class="btn btn-danger d-none"
                                                onclick="cancelEdit('ked')">&#10005;
                                        </button>
                                        <button id="saveBtnked" class="btn btn-success d-none"
                                                onclick="saveChanges('ked', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <ul class="list-group">
                                    <li class="list-group-item list-none-line">
                                        <strong>Почта:</strong> <span id="email">${company.email!}</span>
                                        <button onclick="copyText('email')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnemail" onclick="editText('email', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputemail"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.email!}">
                                        <button id="cancelBtnemail" class="btn btn-danger d-none"
                                                onclick="cancelEdit('email')">&#10005;
                                        </button>
                                        <button id="saveBtnemail" class="btn btn-success d-none"
                                                onclick="saveChanges('email', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Пароль от почты:</strong> <span id="emailPassword"
                                                                                data-password="${company.emailPassword!}"><#list 1..(company.emailPassword!?length) as i>•</#list></span>
                                        <button onclick="copyText('emailPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnemailPassword"
                                                onclick="editText('emailPassword', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('emailPassword')" title="Увидеть"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputemailPassword"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.emailPassword!}">
                                        <button id="cancelBtnemailPassword" class="btn btn-danger d-none"
                                                onclick="cancelEdit('emailPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnemailPassword" class="btn btn-success d-none"
                                                onclick="saveChanges('emailPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>Телефон:</strong> <span id="phone">${company.phone!}</span>
                                        <button onclick="copyText('phone')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnphone" onclick="editText('phone', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputphone"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.phone!}">
                                        <button id="cancelBtnphone" class="btn btn-danger d-none"
                                                onclick="cancelEdit('phone')">&#10005;
                                        </button>
                                        <button id="saveBtnphone" class="btn btn-success d-none"
                                                onclick="saveChanges('phone', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ЭСФ логин:</strong> <span id="esf">${company.esf!}</span>
                                        <button onclick="copyText('esf')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnesf" onclick="editText('esf', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputesf"
                                               class="form-control edit-input d-none fs-5" value="${company.esf!}">
                                        <button id="cancelBtnesf" class="btn btn-danger d-none"
                                                onclick="cancelEdit('esf')">&#10005;
                                        </button>
                                        <button id="saveBtnesf" class="btn btn-success d-none"
                                                onclick="saveChanges('esf', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ЭСФ пароль:</strong> <span id="esfPassword"
                                                                           data-password="${company.esfPassword!}"><#list 1..(company.esfPassword!?length) as i>•</#list></span>
                                        <button onclick="copyText('esfPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnesfPassword"
                                                onclick="editText('esfPassword', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('esfPassword')" title="Увидеть"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputesfPassword"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.esfPassword!}">
                                        <button id="cancelBtnesfPassword" class="btn btn-danger d-none"
                                                onclick="cancelEdit('esfPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnesfPassword" class="btn btn-success d-none"
                                                onclick="saveChanges('esfPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ККМ логин:</strong> <span id="kkm">${company.kkm!}</span>
                                        <button onclick="copyText('kkm')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnkkm" onclick="editText('kkm', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkkm"
                                               class="form-control edit-input d-none fs-5" value="${company.kkm!}">
                                        <button id="cancelBtnkkm" class="btn btn-danger d-none"
                                                onclick="cancelEdit('kkm')">&#10005;
                                        </button>
                                        <button id="saveBtnkkm" class="btn btn-success d-none"
                                                onclick="saveChanges('kkm', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ККМ пароль:</strong> <span id="kkmPassword"
                                                                           data-password="${company.kkmPassword!}"><#list 1..(company.kkmPassword!?length) as i>•</#list></span>
                                        <button onclick="copyText('kkmPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnkkmPassword"
                                                onclick="editText('kkmPassword', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('kkmPassword')" title="Увидеть"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputkkmPassword"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.kkmPassword!}">
                                        <button id="cancelBtnkkmPassword" class="btn btn-danger d-none"
                                                onclick="cancelEdit('kkmPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnkkmPassword" class="btn btn-success d-none"
                                                onclick="saveChanges('kkmPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>1С Фреш логин:</strong>
                                        <span id="fresh1c">${company.fresh1c!}</span>
                                        <button onclick="copyText('fresh1c')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnfresh1c" onclick="editText('fresh1c', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputfresh1c"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.fresh1c!}">
                                        <button id="cancelBtnfresh1c" class="btn btn-danger d-none"
                                                onclick="cancelEdit('fresh1c')">&#10005;
                                        </button>
                                        <button id="saveBtnfresh1c" class="btn btn-success d-none"
                                                onclick="saveChanges('fresh1c', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>1С Фреш пароль:</strong> <span id="fresh1cPassword"
                                                                               data-password="${company.fresh1cPassword!}"><#list 1..(company.fresh1cPassword!?length) as i>•</#list></span>
                                        <button onclick="copyText('fresh1cPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnfresh1cPassword"
                                                onclick="editText('fresh1cPassword', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('fresh1cPassword')"
                                                title="Увидеть" class="btn btn-link p-0">
                                            <i class="bi bi-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputfresh1cPassword"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.fresh1cPassword!}">
                                        <button id="cancelBtnfresh1cPassword" class="btn btn-danger d-none"
                                                onclick="cancelEdit('fresh1cPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnfresh1cPassword" class="btn btn-success d-none"
                                                onclick="saveChanges('fresh1cPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ЭТТН логин:</strong>
                                        <span id="ettn">${company.ettn!}</span>
                                        <button onclick="copyText('ettn')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnettn" onclick="editText('ettn', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputettn"
                                               class="form-control edit-input d-none fs-5" value="${company.ettn!}">
                                        <button id="cancelBtnettn" class="btn btn-danger d-none"
                                                onclick="cancelEdit('ettn')">&#10005;
                                        </button>
                                        <button id="saveBtnettn" class="btn btn-success d-none"
                                                onclick="saveChanges('ettn', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>
                                    <li class="list-group-item list-none-line">
                                        <strong>ЭТТН пароль:</strong>
                                        <span id="ettnPassword"
                                              data-password="${company.ettnPassword!}"><#list 1..(company.ettnPassword!?length) as i>•</#list></span>
                                        <button onclick="copyText('ettnPassword')" title="Скопировать"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-clipboard" style="color: black;"></i>
                                        </button>
                                        <button id="editBtnettnPassword"
                                                onclick="editText('ettnPassword', ${company.id})"
                                                title="Редактировать" class="btn btn-link p-0">
                                            <i class="bi bi-pencil" style="color: black;"></i>
                                        </button>
                                        <button onclick="togglePasswordVisibility('ettnPassword')" title="Увидеть"
                                                class="btn btn-link p-0">
                                            <i class="bi bi-eye" style="color: black;"></i>
                                        </button>
                                        <div class="company-edit">
                                        <input type="text" id="editInputettnPassword"
                                               class="form-control edit-input d-none fs-5"
                                               value="${company.ettnPassword!}">
                                        <button id="cancelBtnettnPassword" class="btn btn-danger d-none"
                                                onclick="cancelEdit('ettnPassword')">&#10005;
                                        </button>
                                        <button id="saveBtnettnPassword" class="btn btn-success d-none"
                                                onclick="saveChanges('ettnPassword', ${company.id})">&#10003;
                                        </button>
                                        </div>
                                    </li>

                                    <li class="list-group-item list-none-line">
                                        <#if company.deleted>
                                            <strong>Состояние:</strong> <span> Удаленная компания</span>
                                        <#else>
                                            <strong>Состояние:</strong> <span> Актуальная компания</span>
                                        </#if>
                                    </li>
                                </ul>
                            </div>
                            <#if isAdmin>
                                <#if company.deleted>
                                    <button type="button" class="btn btn-danger btn-custom-delete"
                                            data-bs-toggle="modal" data-bs-target="#returnModal">
                                        Восстановить Компанию
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
                                <#else>
                                    <button type="button" class="btn btn-danger btn-custom-delete"
                                            data-bs-toggle="modal" data-bs-target="#deleteModal">
                                        Удалить Компанию
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
                                                            компании:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="name" name="name"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("name"))>
                                                                <span class="text-danger">${errors.getFieldError("name").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="companyInn"
                                                               class="col-md-4 col-form-label">ИНН:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="companyInn" name="companyInn"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("inn"))>
                                                                <span class="text-danger">${errors.getFieldError("inn").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="directorInn" class="col-md-4 col-form-label">ИНН
                                                            руководителя:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="directorInn" name="directorInn"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("directorInn"))>
                                                                <span class="text-danger">${errors.getFieldError("directorInn").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="login"
                                                               class="col-md-4 col-form-label">Логин:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="login" name="login"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("login"))>
                                                                <span class="text-danger">${errors.getFieldError("login").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="password"
                                                               class="col-md-4 col-form-label">Пароль:</label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="password" name="password"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("password"))>
                                                                <span class="text-danger">${errors.getFieldError("password").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="ecp" class="col-md-4 col-form-label">ЭЦП:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="ecp" name="ecp" class="form-control"
                                                                   required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("ecp"))>
                                                                <span class="text-danger">${errors.getFieldError("ecp").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="kabinetSalyk" class="col-md-4 col-form-label">Salyk.kg
                                                            логин:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="kabinetSalyk" name="kabinetSalyk"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("kabinetSalyk"))>
                                                                <span class="text-danger">${errors.getFieldError("kabinetSalyk").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="kabinetSalykPassword"
                                                               class="col-md-4 col-form-label">Salyk.kg пароль:</label>
                                                        <div class="col-md-8">
                                                            <input type="password" id="kabinetSalykPassword"
                                                                   name="kabinetSalykPassword" class="form-control"
                                                                   required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("kabinetSalykPassword"))>
                                                                <span class="text-danger">${errors.getFieldError("kabinetSalykPassword").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="taxMode" class="col-md-4 col-form-label">Режим
                                                            налогооблажения:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="taxMode" name="taxMode"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("taxMode"))>
                                                                <span class="text-danger">${errors.getFieldError("taxMode").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="opf" class="col-md-4 col-form-label">ОПФ:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="opf" name="opf" class="form-control"
                                                                   required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("opf"))>
                                                                <span class="text-danger">${errors.getFieldError("opf").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="districtGns" class="col-md-4 col-form-label">Район
                                                            ГНС:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="districtGns" name="districtGns"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("districtGns"))>
                                                                <span class="text-danger">${errors.getFieldError("districtGns").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="socfundNumber" class="col-md-4 col-form-label">Номер
                                                            соцфонда:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="socfundNumber" name="socfundNumber"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("socfundNumber"))>
                                                                <span class="text-danger">${errors.getFieldError("socfundNumber").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="registrationNumberMj"
                                                               class="col-md-4 col-form-label">Регистрационный номер
                                                            МЮ:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="registrationNumberMj"
                                                                   name="registrationNumberMj" class="form-control"
                                                                   required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("registrationNumberMj"))>
                                                                <span class="text-danger">${errors.getFieldError("registrationNumberMj").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="okpo" class="col-md-4 col-form-label">ОКПО:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="okpo" name="okpo"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("okpo"))>
                                                                <span class="text-danger">${errors.getFieldError("okpo").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="director" class="col-md-4 col-form-label">ФИО
                                                            руководителя:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="director" name="director"
                                                                   class="form-control" required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("director"))>
                                                                <span class="text-danger">${errors.getFieldError("director").defaultMessage}</span>
                                                            </#if>
                                                        </div>
                                                    </div>
                                                    <div class="form-group row">
                                                        <label for="ked" class="col-md-4 col-form-label">КЭД:</label>
                                                        <div class="col-md-8">
                                                            <input type="text" id="ked" name="ked" class="form-control"
                                                                   required>
                                                            <#if (errors?has_content && errors.hasFieldErrors("ked"))>
                                                                <span class="text-danger">${errors.getFieldError("ked").defaultMessage}</span>
                                                            </#if>
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
