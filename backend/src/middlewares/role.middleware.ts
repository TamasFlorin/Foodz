import { NextFunction, Response } from 'express';
import { RequestWithUser, User, UserRole } from '@interfaces/user.interface';
import { HttpException } from '@exceptions/http.exception';

const roleMiddleware = (allowedRoles: UserRole[]) => async (req: RequestWithUser, _res: Response, next: NextFunction) => {
  const user: User = req.user;
  if (!user) {
    next(new HttpException(401, 'Invalid auth token.'));
  } else if (!allowedRoles.includes(user.role)) {
    next(new HttpException(401, 'This user does not have the required role to perform this action.'));
  } else {
    next();
  }
};

export default roleMiddleware;
