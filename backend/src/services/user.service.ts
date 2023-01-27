import { RefreshToken } from '@interfaces/token.interface';
import { jwtConfig } from '@configs/jwt.config';
import { RegisterUserDto, LoginUserDto, GetUserInfoDto, RefreshTokenDto, GetUsersDto, UpdateUserDto, DeleteUserDto } from '@dtos/user.dto';
import { HttpException } from '@exceptions/http.exception';
import { TokenData, TokenPayload, User, UserRole, Users } from '@interfaces/user.interface';
import randomToken from 'random-token';
import userModel from '@models/user.model';
import refreshTokenModel from '@models/token.model';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { Status } from '@interfaces/status.interface';
export default class UserService {
  public users = userModel;
  public tokens = refreshTokenModel;

  public async createUser(user: RegisterUserDto): Promise<User> {
    if (user.role == UserRole.Admin) throw new HttpException(400, 'Invalid user role provided!');

    const existingUser: User = await this.users.findOne({ email: user.email }).select('+password');
    if (existingUser) throw new HttpException(409, 'Email already taken.');

    const hashedPassword = await bcrypt.hash(user.password, 10);
    const createUserData: User = await this.users.create({ ...user, password: hashedPassword });

    return createUserData;
  }

  public async login(userInfo: LoginUserDto): Promise<TokenData> {
    const existingUser: User = await this.users.findOne({ email: userInfo.email }).select('+password');
    if (!existingUser) throw new HttpException(409, 'No user with this email address was found.');
    if (existingUser.status === Status.Disabled) throw new HttpException(409, 'This account is disabled.');

    const isPasswordMatch = await bcrypt.compare(userInfo.password, existingUser.password);
    if (!isPasswordMatch) throw new HttpException(409, 'Invalid password provided.');

    const refreshToken: RefreshToken = await this.generateRefreshToken(existingUser);
    return this.generateTokenData(existingUser, refreshToken);
  }

  public async refreshToken(refreshTokenInfo: RefreshTokenDto): Promise<TokenData> {
    const refreshToken = await this.tokens.findOne({ token: refreshTokenInfo.token });
    if (!refreshToken) throw new HttpException(409, 'The provided refresh token does not exist.');
    if (refreshToken.revoked) throw new HttpException(409, 'The provided refresh token was revoved.');

    const user: User = await this.users.findOne({ _id: refreshToken.userId });
    if (!user) throw new HttpException(409, 'The user associated to this token no longer exists.');
    if (user.status == Status.Disabled) throw new HttpException(409, 'The user associated to this token is disabled.');

    return this.generateTokenData(user, refreshToken);
  }

  public async getInfo(userInfo: GetUserInfoDto, user: User): Promise<User> {
    const existingUser: User = await this.users.findOne({ _id: userInfo.id });
    if (!existingUser) throw new HttpException(404, 'No user with this id was found.');
    if (existingUser.status === Status.Disabled && user.role != UserRole.Admin) throw new HttpException(409, 'This account is disabled.');

    return existingUser;
  }

  public async getAll(dto: GetUsersDto): Promise<Users> {
    const users: User[] = await this.users
      .find({})
      .skip(dto.paginationOptions.itemsPerPage * dto.paginationOptions.pageNumber)
      .limit(dto.paginationOptions.itemsPerPage);
    return { users: users };
  }

  public async update(dto: UpdateUserDto): Promise<User> {
    const user: User = await this.users.findOneAndUpdate({ _id: dto.id }, { ...dto }, { new: true });
    if (!user) throw new HttpException(404, 'No user with this id was found.');
    return user;
  }

  public async delete(dto: DeleteUserDto): Promise<User> {
    const user: User = await this.users.findOneAndUpdate({ _id: dto.id }, { status: Status.Disabled }, { new: true });
    if (!user) throw new HttpException(404, 'No user with this id was found.');
    return user;
  }

  private async generateRefreshToken(user: User): Promise<RefreshToken> {
    const refreshToken: RefreshToken = await this.tokens.create({ userId: user._id, token: randomToken(40) });
    return refreshToken;
  }

  private generateTokenData(user: User, refreshToken: RefreshToken): TokenData {
    const tokenPayload: TokenPayload = { userId: user._id };
    const jwtToken = jwt.sign(tokenPayload, jwtConfig.secret, { expiresIn: jwtConfig.expiration });
    return { token: jwtToken, refreshToken: refreshToken.token, userId: user._id, role: user.role, expiresIn: jwtConfig.expiration };
  }
}
