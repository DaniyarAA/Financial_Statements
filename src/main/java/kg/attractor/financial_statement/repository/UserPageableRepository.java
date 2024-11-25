package kg.attractor.financial_statement.repository;

import kg.attractor.financial_statement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserPageableRepository extends PagingAndSortingRepository<User, Long> {
    Page<User> findAllByOrderByEnabledDescIdAsc(Pageable pageable);
}
