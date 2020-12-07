import { Resolver, Query, Mutation, Ctx, Arg, Int } from "type-graphql";
import { ILike } from "typeorm";

import { Property } from "../../entity/Property";

import { CreatePropertyInput } from "./CreatePropertyInput";
import { PropertyFilterInput } from "./PropertyFilterInput";
import { DeletePropertyInput } from "./DeletePropertyInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

import { PropertyInput } from "./PropertyInput"

@Resolver()
export class PropertyResolver {
	@Query(() => [Property])
	properties(@Arg("filter") filter: PropertyFilterInput) {
		return Property.find({
			where: [
                { address: ILike("%" + filter.search + "%") },
                { postalCode: ILike("%" + filter.search + "%") },
                { city: ILike("%" + filter.search + "%") },
            ],
			relations: ["user"]
		})
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

	// @Arg("data") data: CreatePropertyInput, 
	@Mutation(() => Property, { nullable: true })
	async createProperty(@Arg("data") data: CreatePropertyInput, @Ctx() ctx: MyContext) {

		console.log(ctx.req.session)// TODO: ne devrait pas être nul

		const user = await User.findOne({ id: data.userId || ctx.req.session!.userId })
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

	@Mutation(() => Int)
	async deleteProperty(@Arg("data") data: DeletePropertyInput) {

		const property2 = await Property.delete(data.propertyId)

		console.log('delete property: ', property2)

		if (property2.affected !== 1) return 0

		return 1
	}

}
