<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Create Company</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="/css/style.css">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center">Create Company</h1>
    <form action="/company/create" method="post">
        <#if _csrf??>
            <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                   value="${(_csrf.token)!'csrf-token'}"/>
        </#if>
        <fieldset class="border p-4 mb-4">
            <legend class="w-auto">Mandatory Fields</legend>
            <div class="form-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" class="form-control" value="${company.name?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("name"))>
                    <span class="text-danger">${errors.getFieldError("name").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="inn">INN:</label>
                <input type="text" id="inn" name="inn" class="form-control" value="${company.inn?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("inn"))>
                    <span class="text-danger">${errors.getFieldError("inn").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="directorInn">Director INN:</label>
                <input type="text" id="directorInn" name="directorInn" class="form-control" value="${company.directorInn?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("directorInn"))>
                    <span class="text-danger">${errors.getFieldError("directorInn").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="login">Login:</label>
                <input type="text" id="login" name="login" class="form-control" value="${company.login?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("login"))>
                    <span class="text-danger">${errors.getFieldError("login").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" class="form-control" value="${company.password?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("password"))>
                    <span class="text-danger">${errors.getFieldError("password").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="ecp">ECP:</label>
                <input type="text" id="ecp" name="ecp" class="form-control" value="${company.ecp?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("ecp"))>
                    <span class="text-danger">${errors.getFieldError("ecp").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="kabinetSalyk">Kabinet Salyk:</label>
                <input type="text" id="kabinetSalyk" name="kabinetSalyk" class="form-control" value="${company.kabinetSalyk?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("kabinetSalyk"))>
                    <span class="text-danger">${errors.getFieldError("kabinetSalyk").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="kabinetSalykPassword">Kabinet Salyk Password:</label>
                <input type="password" id="kabinetSalykPassword" name="kabinetSalykPassword" class="form-control" value="${company.kabinetSalykPassword?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("kabinetSalykPassword"))>
                    <span class="text-danger">${errors.getFieldError("kabinetSalykPassword").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="taxMode">Tax Mode:</label>
                <input type="text" id="taxMode" name="taxMode" class="form-control" value="${company.taxMode?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("taxMode"))>
                    <span class="text-danger">${errors.getFieldError("taxMode").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="opf">OPF:</label>
                <input type="text" id="opf" name="opf" class="form-control" value="${company.opf?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("opf"))>
                    <span class="text-danger">${errors.getFieldError("opf").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="districtGns">District GNS:</label>
                <input type="text" id="districtGns" name="districtGns" class="form-control" value="${company.districtGns?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("districtGns"))>
                    <span class="text-danger">${errors.getFieldError("districtGns").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="socfundNumber">SocFund Number:</label>
                <input type="text" id="socfundNumber" name="socfundNumber" class="form-control" value="${company.socfundNumber?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("socfundNumber"))>
                    <span class="text-danger">${errors.getFieldError("socfundNumber").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="registrationNumberMj">Registration Number MJ:</label>
                <input type="text" id="registrationNumberMj" name="registrationNumberMj" class="form-control" value="${company.registrationNumberMj?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("registrationNumberMj"))>
                    <span class="text-danger">${errors.getFieldError("registrationNumberMj").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="okpo">OKPO:</label>
                <input type="text" id="okpo" name="okpo" class="form-control" value="${company.okpo?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("okpo"))>
                    <span class="text-danger">${errors.getFieldError("okpo").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="director">Director:</label>
                <input type="text" id="director" name="director" class="form-control" value="${company.director?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("director"))>
                    <span class="text-danger">${errors.getFieldError("director").defaultMessage}</span>
                </#if>
            </div>
            <div class="form-group">
                <label for="ked">KED:</label>
                <input type="text" id="ked" name="ked" class="form-control" value="${company.ked?if_exists}">
                <#if (errors?has_content && errors.hasFieldErrors("ked"))>
                    <span class="text-danger">${errors.getFieldError("ked").defaultMessage}</span>
                </#if>
            </div>
        </fieldset>

        <fieldset class="border p-4 mb-4">
            <legend class="w-auto">Optional Fields</legend>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" class="form-control" value="${company.email?if_exists}">
            </div>
            <div class="form-group">
                <label for="emailPassword">Email Password:</label>
                <input type="password" id="emailPassword" name="emailPassword" class="form-control" value="${company.emailPassword?if_exists}">
            </div>
            <div class="form-group">
                <label for="phone">Phone:</label>
                <input type="text" id="phone" name="phone" class="form-control" value="${company.phone?if_exists}">
            </div>
            <div class="form-group">
                <label for="esf">ESF:</label>
                <input type="text" id="esf" name="esf" class="form-control" value="${company.esf?if_exists}">
            </div>
            <div class="form-group">
                <label for="esfPassword">ESF Password:</label>
                <input type="password" id="esfPassword" name="esfPassword" class="form-control" value="${company.esfPassword?if_exists}">
            </div>
            <div class="form-group">
                <label for="kkm">KKM:</label>
                <input type="text" id="kkm" name="kkm" class="form-control" value="${company.kkm?if_exists}">
            </div>
            <div class="form-group">
                <label for="kkmPassword">KKM Password:</label>
                <input type="password" id="kkmPassword" name="kkmPassword" class="form-control" value="${company.kkmPassword?if_exists}">
            </div>

            <div class="form-group">
                <label for="fresh1c">Fresh 1C:</label>
                <input type="text" id="fresh1c" name="fresh1c" class="form-control" value="${company.fresh1c?if_exists}">
            </div>
            <div class="form-group">
                <label for="fresh1cPassword">Fresh 1C Password:</label>
                <input type="password" id="fresh1cPassword" name="fresh1cPassword" class="form-control" value="${company.fresh1cPassword?if_exists}">
            </div>
            <div class="form-group">
                <label for="ettn">ETTN:</label>
                <input type="text" id="ettn" name="ettn" class="form-control" value="${company.ettn?if_exists}">
            </div>
            <div class="form-group">
                <label for="ettnPassword">ETTN Password:</label>
                <input type="password" id="ettnPassword" name="ettnPassword" class="form-control" value="${company.ettnPassword?if_exists}">
            </div>
        </fieldset>


        <button type="submit" class="btn btn-primary btn-block">Submit</button>
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
