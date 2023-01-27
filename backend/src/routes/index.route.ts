import AppRoute from '@interfaces/route.interface';
import { NextFunction, Request, Response, Router } from 'express';

class IndexRoute implements AppRoute {
  public path = '/';
  public router = Router();

  constructor() {
    this.router.get('/', function (req: Request, res: Response, _: NextFunction) {
      res.send('called index/');
    });
  }
}

export default IndexRoute;
