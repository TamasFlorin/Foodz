import { Status } from '@interfaces/status.interface';
import { UserRole } from '@interfaces/user.interface';
import { IsEmail, IsEnum, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { PaginationOptions } from './pagination.options.dto';

export class RegisterUserDto {
  @IsEmail()
  public email: string;

  @IsString()
  @IsNotEmpty()
  public password: string;

  @IsEnum(UserRole)
  public role: UserRole;

  @IsString()
  @IsNotEmpty()
  public firstName: string;

  @IsString()
  @IsNotEmpty()
  public lastName: string;
}

export class LoginUserDto {
  @IsEmail()
  public email: string;

  @IsString()
  @IsNotEmpty()
  public password: string;
}

export class GetUserInfoDto {
  @IsString()
  @IsNotEmpty()
  public id: string;
}

export class RefreshTokenDto {
  @IsString()
  @IsNotEmpty()
  public token: string;
}

export class GetUsersDto {
  @IsOptional()
  paginationOptions: PaginationOptions;
}

export class UpdateUserDto {
  @IsString()
  @IsNotEmpty()
  public id: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  public firstName: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  public lastName: string;

  @IsOptional()
  @IsEnum(Status)
  public status: Status;
}

export class DeleteUserDto {
  @IsString()
  @IsNotEmpty()
  public id: String;
}
