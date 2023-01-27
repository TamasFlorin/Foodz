import AppRoute from '@interfaces/route.interface';
import UserController from '@controllers/user.controller';
import { Router } from 'express';
import validationMiddleware from '@middlewares/validation.middleware';
import { RegisterUserDto, LoginUserDto, GetUserInfoDto, RefreshTokenDto, GetUsersDto, UpdateUserDto, DeleteUserDto } from '@dtos/user.dto';
import authMiddleware from '@middlewares/auth.middleware';
import roleMiddleware from '@middlewares/role.middleware';
import { UserRole } from '@interfaces/user.interface';

export default class UsersRoute implements AppRoute {
  public path = '/users';
  public router = Router();

  private userController = new UserController();

  constructor() {
    this.router.post('/register', validationMiddleware(RegisterUserDto, 'body'), this.userController.createUser);
    this.router.post('/login', validationMiddleware(LoginUserDto, 'body'), this.userController.loginUser);
    this.router.post('/refreshToken', validationMiddleware(RefreshTokenDto, 'body'), this.userController.refreshToken);
    this.router.get('/get/:id', validationMiddleware(GetUserInfoDto, 'params'), authMiddleware, this.userController.getInfo);
    this.router.delete(
      '/delete/:id',
      validationMiddleware(DeleteUserDto, 'params'),
      authMiddleware,
      roleMiddleware([UserRole.Admin]),
      this.userController.delete,
    );
    this.router.post('/get', validationMiddleware(GetUsersDto, 'body'), authMiddleware, roleMiddleware([UserRole.Admin]), this.userController.getAll);
    this.router.put(
      '/update',
      validationMiddleware(UpdateUserDto, 'body'),
      authMiddleware,
      roleMiddleware([UserRole.Admin]),
      this.userController.update,
    );
  }
}
