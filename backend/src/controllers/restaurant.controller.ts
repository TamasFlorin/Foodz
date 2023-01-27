import { RequestWithUser } from '@interfaces/user.interface';
import { CreateRestaurantDto, DeleteRestaurantDto, GetRestaurantDto, GetRestaurantsDto, UpdateRestaurantDto } from '@dtos/restaurant.dto';
import { Restaurant, Restaurants } from '@interfaces/restaurant.interface';
import RestaurantService from '@services/restaurant.service';
import { NextFunction, Request, Response } from 'express';
import { PaginationOptions } from '@dtos/pagination.options.dto';

export default class RestaurantController {
  private restaurantService = new RestaurantService();

  public create = async (req: RequestWithUser, res: Response, next: NextFunction) => {
    try {
      const restaurantDto: CreateRestaurantDto = req.body;
      const restaurant: Restaurant = await this.restaurantService.create(restaurantDto, req.user);
      res.status(201).json({ data: restaurant, message: 'Restaurant successfully created.' });
    } catch (error) {
      next(error);
    }
  };

  public getAll = async (req: RequestWithUser, res: Response, next: NextFunction) => {
    try {
      const dto: GetRestaurantsDto = { paginationOptions: new PaginationOptions(), ...req.body };
      const restaurants: Restaurants = await this.restaurantService.getAll(dto);
      res.status(200).json({ data: restaurants, message: 'Restaurants successfully retrived.' });
    } catch (error) {
      next(error);
    }
  };

  public get = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dto: GetRestaurantDto = { id: req.params.id };
      const restaurant: Restaurant = await this.restaurantService.get(dto);
      res.status(200).json({ data: restaurant, message: 'Restaurant successfully retrived.' });
    } catch (error) {
      next(error);
    }
  };

  public delete = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dto: DeleteRestaurantDto = { id: req.params.id };
      const restaurant: Restaurant = await this.restaurantService.delete(dto);
      res.status(200).json({ data: restaurant, message: 'Restaurant successfully removed.' });
    } catch (error) {
      next(error);
    }
  };

  public update = async (req: Request, res: Response, next: NextFunction) => {
    try {
      const dto: UpdateRestaurantDto = req.body;
      const restaurant: Restaurant = await this.restaurantService.update(dto);
      res.status(200).json({ data: restaurant, message: 'Restaurant successfully updated.' });
    } catch (error) {
      next(error);
    }
  };
}
