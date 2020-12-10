import { Resolver, Query, Mutation, Ctx, Arg, Int, Authorized } from "type-graphql";
import { /* ILike, */getManager } from "typeorm";
import { buildPaginator } from "typeorm-cursor-pagination";

// import { GraphQLJSONObject } from 'graphql-type-json';

import { Property } from "../../entity/Property";

import { CreatePropertyInput } from "./CreatePropertyInput";
import { PropertyFilterInput } from "./PropertyFilterInput";
import { DeletePropertyInput } from "./DeletePropertyInput";
import { UpdatePropertyInput } from "./UpdatePropertyInput";
import { PropertyPaginationInput } from "./PropertyPaginationInput";

import { PropertiesOutput } from "./PropertiesOutput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

import { PropertyInput } from "./PropertyInput"

@Resolver()
export class PropertyResolver {
	@Authorized()
	@Query(() => PropertiesOutput)// TODO: récupérer le schema graphql et définir un bon schema output
	// @ts-ignore
	async properties(@Arg("filter", { nullable: true }) filter?: PropertyFilterInput, @Arg("pagination", { nullable: true }) pagination?: PropertyPaginationInput, @Ctx() ctx: MyContext) {
		console.log('properties: ', ctx.userId)
		
		// const properties2 = Property.find({
		// 	where: filter ? [
        //         { address: ILike("%" + filter.search + "%"), user: { id: ctx.userId } },
        //         { postalCode: ILike("%" + filter.search + "%"), user: { id: ctx.userId } },
        //         { city: ILike("%" + filter.search + "%"), user: { id: ctx.userId } },
        //     ] : [
		// 		{ user: { id: ctx.userId } }
		// 	],// TODO: OrderInput
		// 	take: pagination && pagination.take,
		// 	skip: pagination && pagination.skip,
		// 	relations: ["user"]
		// })


		const queryBuilder = await getManager()
			.createQueryBuilder(Property, "property")
			.leftJoinAndSelect('property.user', 'user')
			.where('property.user.id = :userId', { userId: ctx.userId })
			.andWhere("property.address ilike '%' || :address || '%'", { address: filter ? filter.search : "" })
			.orWhere("property.postalCode ilike '%' || :postalCode || '%'", { postalCode: filter ? filter.search : "" })
			.orWhere("property.city ilike '%' || :city || '%'", { city: filter ? filter.search : "" })
			// .take(pagination && pagination.take)
			// .skip(pagination && pagination.skip)
			// .getMany();

		const paginator = buildPaginator({
			entity: Property,
			query: {
				limit: pagination && pagination.limit ? pagination.limit : 10,
				order: 'ASC',
				afterCursor: pagination && pagination.afterCursor,
				beforeCursor: pagination && pagination.beforeCursor
			},
		})

		const { data, cursor } = await paginator.paginate(queryBuilder)

		console.log('cursor: ', cursor)

		return {
			data,
			cursor
		}
	}

	@Query(() => Property, { nullable: true })
	async property(@Arg("data") data: PropertyInput) {

		// console.log(ctx.req.session)// TODO: ne devrait pas être nul
		
		// @ts-ignore
		const property = await Property.findOne({ id: data.propertyId }, { relations: ["user"] })
		if (!property) return

		// console.log('properties: ', property.properties)

		return property;
	}

	@Authorized()
	@Mutation(() => Property, { nullable: true })
	async createProperty(@Arg("data") data: CreatePropertyInput, @Ctx() ctx: MyContext) {

		// @ts-ignore
		const user = await User.findOne({ id: ctx.userId })
		if (!user) return
		
		const property = await Property.create({
			address: data.address,
			postalCode: data.postalCode,
			city: data.city,
			user: user
		}).save();

		console.log(property)

		// await property.save();
		return property;
	}

	@Authorized()
	@Mutation(() => Int)
	async updateProperty(@Arg("data") data: UpdatePropertyInput) {

		const property = await Property.update(data.propertyId, {
			address: data.property.address,
			postalCode: data.property.postalCode,
			city: data.property.city,
		})
		console.log('updateProperty: ', property)

		if (property.affected !== 1) return 0

		return 1
	}

	@Authorized()
	@Mutation(() => Int)
	async deleteProperty(@Arg("data") data: DeletePropertyInput) {

		const property = await Property.delete(data.propertyId)

		console.log('deleteProperty: ', property)

		if (property.affected !== 1) return 0

		return 1
	}

}
