import { Resolver, Query, Mutation, Ctx, Arg } from "type-graphql";

import { Property } from "../../entity/Property";

import { CreatePropertyInput } from "./CreatePropertyInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

import { PropertyInput } from "./PropertyInput"

@Resolver()
export class PropertyResolver {
	@Query(() => [Property])
	properties() {
		return Property.find({ relations: ["user"] })
	}

	@Query(() => Property, { nullable: true })
	async property(@Arg("data") data: PropertyInput) {

		// console.log(ctx.req.session)// TODO: ne devrait pas être nul

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
			user: user
		}).save();

		console.log(property)

		// await property.save();
		return property;
	}
}
