package dev.siyoung.plantit.plantitbe.repository;

import dev.siyoung.plantit.plantitbe.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User,Long> {
}
