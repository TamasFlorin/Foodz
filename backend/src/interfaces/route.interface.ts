import { Router } from 'express';

interface AppRoute {
  path: string;
  router: Router;
}

export default AppRoute;
