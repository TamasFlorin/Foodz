import {
  CreateRestaurantDto,
  DeleteRestaurantDto,
  FilterOperator,
  FilterOptions,
  FilterRelation,
  FilterRelations,
  GetRestaurantDto,
  GetRestaurantsDto,
  UpdateRestaurantDto,
} from '@dtos/restaurant.dto';
import { HttpException } from '@exceptions/http.exception';
import { Restaurant, Restaurants } from '@interfaces/restaurant.interface';
import { Status } from '@interfaces/status.interface';
import { User } from '@interfaces/user.interface';
import restaurantModel from '@models/restaurant.model';
import { filterOptionsToMongoQuery } from '@utils/utils';

export default class RestaurantService {
  private restaurants = restaurantModel;

  public async create(restaurantInfo: CreateRestaurantDto, user: User): Promise<Restaurant> {
    const restaurant: Restaurant = await this.restaurants.create({ ...restaurantInfo, ownerId: user._id });
    return restaurant;
  }

  public async getAll(dto: GetRestaurantsDto): Promise<Restaurants> {
    const restaurants: Restaurant[] = await this.restaurants
      .where({ status: Status.Active, ...filterOptionsToMongoQuery(dto.filterOptions) })
      .sort({ ...dto.sortOptions })
      .skip(dto.paginationOptions.pageNumber * dto.paginationOptions.itemsPerPage)
      .limit(dto.paginationOptions.itemsPerPage);
    return { restaurants: restaurants };
  }

  public async get(dto: GetRestaurantDto): Promise<Restaurant> {
    const restaurant: Restaurant = await this.restaurants.findOne({ _id: dto.id, status: Status.Active });
    if (!restaurant) {
      throw new HttpException(404, 'No restaurant with this id was found.');
    }
    return restaurant;
  }

  public async delete(dto: DeleteRestaurantDto): Promise<Restaurant> {
    const updatedRestaurant: Restaurant = await this.restaurants.findOneAndUpdate(
      { _id: dto.id, status: Status.Active },
      { status: Status.Disabled },
      { new: true },
    );
    if (!updatedRestaurant) {
      throw new HttpException(404, 'No restaurant with this id was found.');
    }

    return updatedRestaurant;
  }

  public async update(dto: UpdateRestaurantDto): Promise<Restaurant> {
    const updatedRestaurant: Restaurant = await this.restaurants.findOneAndUpdate(
      { _id: dto.id, status: Status.Active },
      { name: dto.name, address: dto.address },
      { new: true },
    );
    if (!updatedRestaurant) {
      throw new HttpException(404, 'No restaurant with this id was found.');
    }

    return updatedRestaurant;
  }
}
