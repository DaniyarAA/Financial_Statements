package kg.attractor.financial_statement.controller;

import jakarta.validation.Valid;
import kg.attractor.financial_statement.dto.CompanyDto;
import kg.attractor.financial_statement.service.CompanyService;
import kg.attractor.financial_statement.service.TaskService;
import kg.attractor.financial_statement.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyController {
    private final CompanyService companyService;
    private final UserService userService;
    private final TaskService taskService;

    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<Map<String, String>> create(
             @Valid CompanyDto companyDto,
            BindingResult bindingResult,
            Principal principal) {
        return companyService.createCompany(companyDto, principal.getName(), bindingResult);
    }

    @GetMapping("/all")
    public String getAll(@RequestParam(required = false, defaultValue = "0") Long companyId,
                         @RequestParam(value = "sort", defaultValue = "actual") String sort,
                         @RequestParam(value = "openModal", required = false, defaultValue = "false") boolean openModal,
                         Model model, Principal principal) {

        List<CompanyDto> allCompanies = companyService.getAllCompaniesBySort(sort,principal.getName());
        model.addAttribute("list", allCompanies);

        if (companyId != 0) {
            model.addAttribute("company", companyService.findByIdInUserList(allCompanies,companyId));
            model.addAttribute("companyId", companyId);
        } else if (allCompanies.isEmpty()) {
            model.addAttribute("company", new CompanyDto());
            model.addAttribute("companyId", companyId);
        } else {
            model.addAttribute("company", allCompanies.getFirst());
            model.addAttribute("companyId", allCompanies.getFirst().getId());
        }

        boolean canDelete = false;
        boolean canEdit = false;
        boolean canCreate = false;
        boolean canReturn = false;
        if (principal != null) {
            canDelete = userService.isAdmin(principal.getName());
            canEdit = userService.canEdit(principal.getName());
            canCreate = userService.canCreate(principal.getName());
            canReturn = userService.canReturn(principal.getName());
        }
        model.addAttribute("canDelete", canDelete);
        model.addAttribute("sort", sort);
        model.addAttribute("openModal", openModal);
        model.addAttribute("canEdit", canEdit);
        model.addAttribute("canCreate", canCreate);
        model.addAttribute("canReturn", canReturn);
        return "company/companies";
    }

    @PostMapping("/edit")
    @ResponseBody
    public ResponseEntity<Map<String, String>> update(@RequestBody Map<String, String> data ,Principal principal) {
        return companyService.editByOne(data , principal.getName());
    }

    @PostMapping("/delete")
    public String deleteById(@RequestParam Long companyId , Principal principal) {
        companyService.deleteCompany(companyId , principal.getName());
        return "redirect:/company/all?sort=actual";
    }

    @PostMapping("/return")
    public String returnById(@RequestParam Long companyId , Principal principal) {
        companyService.returnCompany(companyId , principal.getName());
        taskService.tasksGenerator();
        return "redirect:/company/all?sort=actual";
    }
}
