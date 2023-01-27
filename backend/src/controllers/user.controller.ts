import { RegisterUserDto, LoginUserDto, GetUserInfoDto, RefreshTokenDto, GetUsersDto, UpdateUserDto, DeleteUserDto } from '@dtos/user.dto';
import { RequestWithUser, TokenData, User, Users } from '@interfaces/user.interface';
import UserService from '@services/user.service';
import { NextFunction, Request, Response } from 'express';
import { PaginationOptions } from '@dtos/pagination.options.dto';

export default class UserController {
  private userService = new UserService();

  public createUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userDto: RegisterUserDto = req.body;
      const user: User = await this.userService.createUser(userDto);
      res.status(201).json({ data: user, message: 'User successfully created.' });
    } catch (error) {
      next(error);
    }
  };

  public loginUser = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const userInfo: LoginUserDto = req.body;
      const tokenData: TokenData = await this.userService.login(userInfo);
      res.status(200).json({ data: tokenData, message: 'User successfully logged in.' });
    } catch (error) {
      next(error);
    }
  };

  public refreshToken = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const refreshTokenInfo: RefreshTokenDto = req.body;
      const tokenData: TokenData = await this.userService.refreshToken(refreshTokenInfo);
      res.status(200).json({ data: tokenData, message: 'Token sucessfully refreshed.' });
    } catch (error) {
      next(error);
    }
  };

  public getInfo = async (req: RequestWithUser, res: Response, next: NextFunction) => {
    try {
      const userInfo: GetUserInfoDto = { id: req.params.id };
      const currentUser: User = await this.userService.getInfo(userInfo, req.user);
      res.status(200).json({ data: currentUser, message: 'User information was successfully retrieved.' });
    } catch (error) {
      next(error);
    }
  };

  public getAll = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dto: GetUsersDto = { paginationOptions: new PaginationOptions(), ...req.body };
      const users: Users = await this.userService.getAll(dto);
      res.status(200).json({ data: users, message: 'Users successfully retrieved.' });
    } catch (error) {
      next(error);
    }
  };

  public update = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dto: UpdateUserDto = req.body;
      const user: User = await this.userService.update(dto);
      res.status(200).json({ data: user, message: 'User successfully updated.' });
    } catch (error) {
      next(error);
    }
  };

  public delete = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dto: DeleteUserDto = { id: req.params.id };
      const user: User = await this.userService.delete(dto);
      res.status(200).json({ data: user, message: 'User successfully deleted.' });
    } catch (error) {
      next(error);
    }
  };
}
