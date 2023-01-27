import { NextFunction, Response } from 'express';
import jwt from 'jsonwebtoken';
import { jwtConfig } from '@configs/jwt.config';
import { RequestWithUser, TokenPayload } from '@interfaces/user.interface';
import userModel from '@models/user.model';
import { HttpException } from '@exceptions/http.exception';
import { Status } from '@interfaces/status.interface';

const authMiddleware = async (req: RequestWithUser, _res: Response, next: NextFunction) => {
  try {
    const authorization = req.cookies['Authorization'] || req.header('Authorization').split('Bearer ')[1] || null;
    if (authorization) {
      const tokenPayload = jwt.verify(authorization, jwtConfig.secret) as TokenPayload;
      const existingUser = await userModel.findById(tokenPayload.userId);
      if (existingUser) {
        if (existingUser.status == Status.Disabled) {
          next(new HttpException(401, 'User account disabled.'));
        } else {
          req.user = existingUser;
          next();
        }
      } else {
        next(new HttpException(401, 'Invalid auth token.'));
      }
    } else {
      next(new HttpException(404, 'Auth token is missing.'));
    }
  } catch (_) {
    next(new HttpException(401, 'Invalid auth token.'));
  }
};

export default authMiddleware;
