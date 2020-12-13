import { Resolver, Query, Mutation, Ctx, Arg, Int, Authorized } from "type-graphql";
import { /*getManager,*/ ILike, getConnection } from "typeorm";

import { StateOfPlay } from "../../entity/StateOfPlay";

import { CreateStateOfPlayInput } from "./CreateStateOfPlayInput";
import { StateOfPlaysFilterInput } from "./StateOfPlaysFilterInput";
import { DeleteStateOfPlayInput } from "./DeleteStateOfPlayInput";
import { UpdateStateOfPlayInput } from "./UpdateStateOfPlayInput";
import { StateOfPlayInput } from "./StateOfPlayInput"

import { MyContext } from "../../types/MyContext";

import { User } from "../../entity/User";
import { Property } from "../../entity/Property";
import { Owner } from "../../entity/Owner";
import { Representative } from "../../entity/Representative";
import { Tenant } from "../../entity/Tenant";

@Resolver()
export class StateOfPlayResolver {
	@Authorized()
	@Query(() => [StateOfPlay])
	// @ts-ignore
	async stateOfPlays(@Arg("filter", { nullable: true }) filter?: StateOfPlaysFilterInput, @Ctx() ctx: MyContext) {

		const wheres : any = filter ? [
			// { property: { address: ILike("%" + filter.search + "%") } },
			// { property: { postalCode: ILike("%" + filter.search + "%") } },
			// { property: { city: ILike("%" + filter.search + "%") } },
			{ fullAddress: ILike("%" + filter.search + "%"), user: { id: ctx.userId } },
			{ ownerFullName: ILike("%" + filter.search + "%"), user: { id: ctx.userId } },
			{ tenantsFullName: ILike("%" + filter.search + "%"), user: { id: ctx.userId } }
		] : [
			{ user: { id: ctx.userId }}
		]

		if (!filter || filter && filter.in === undefined && filter.out === undefined || filter && filter.in && filter.out) {}
		else
			for (let i = 0; i < wheres.length; i++) {
				wheres[i].out = filter.out
			}

		return StateOfPlay.find({// TODO: filter ne marche pas, trouver une autre solution. => QueryBuilder, ne marche pas non plus => solution implémenter sauvegarder fullAdress sur l'entité StateOfPlay
			where: wheres,
			relations: ["user", "owner", "representative", "property", "tenants"]
		})

		// const stateOfPlays = await getManager()
		// 	.createQueryBuilder(StateOfPlay, "stateOfPlay")
		// 	.leftJoinAndSelect('stateOfPlay.user', 'user')
		// 	.leftJoinAndSelect('stateOfPlay.owner', 'owner')
		// 	.leftJoinAndSelect('stateOfPlay.representative', 'representative')
		// 	.leftJoinAndSelect('stateOfPlay.property', 'property')
		// 	.where('stateOfPlay.user.id = :userId', { userId: ctx.userId })
		// 	.andWhere("stateOfPlay.property.address ilike '%' || :address || '%'", { address: filter ? filter.search : "" })
		// 	// .orWhere("stateOfPlay.property.postalCode ilike '%' || :postalCode || '%'", { postalCode: filter ? filter.search : "" })
		// 	// .orWhere("stateOfPlay.property.city ilike '%' || :city || '%'", { city: filter ? filter.search : "" })
		// 	// .take(pagination && pagination.take)
		// 	// .skip(pagination && pagination.skip)
		// 	.getMany();

		// return stateOfPlays
	}

	@Authorized()
	@Query(() => StateOfPlay, { nullable: true })
	async stateOfPlay(@Arg("data") data: StateOfPlayInput) {

		// @ts-ignore
		const stateOfPlay = await StateOfPlay.findOne({ id: data.stateOfPlayId }, { relations: ["user", "owner", "representative", "property", "tenants"] })
		if (!stateOfPlay) return


		return stateOfPlay;
	}

	@Authorized()
	@Mutation(() => StateOfPlay, { nullable: true })
	async createStateOfPlay(@Arg("data") data: CreateStateOfPlayInput, @Ctx() ctx: MyContext) {

		// @ts-ignore
		const user = await User.findOne({ id: ctx.userId })
		if (!user) return
		console.log('user: ', user)

		// @ts-ignore
		var owner = data.owner.id && await Owner.findOne({ id: data.owner.id })
		if (!owner) {
			owner = await Owner.create({
				firstName: data.owner.firstName,
				lastName: data.owner.lastName,
				user: user,
			}).save();
		}
		console.log('owner: ', owner)
		
		// @ts-ignore
		var representative = data.representative.id && await Representative.findOne({ id: data.representative.id })
		if (!representative) {
			representative = await Representative.create({
				firstName: data.representative.firstName,
				lastName: data.representative.lastName,
				user: user,
			}).save();
		}
		console.log('representative: ', representative)

		const tenants = []
		for(let i = 0; i < data.tenants.length; i++) {
			// @ts-ignore
			var tenant = data.tenants[i].id && await Tenant.findOne({ id: data.tenants[i].id })
			if (!tenant) {
				tenant = await Tenant.create({
					firstName: data.tenants[i].firstName,
					lastName: data.tenants[i].lastName,
					user: user,
				}).save();
			}
			tenants.push(tenant)
		}
		console.log('tenants[0]: ', tenants[0])
		
		// @ts-ignore
		var property = data.property.id && await Property.findOne({ id: data.property.id })
		if (!property) {
			property = await Property.create({
				address: data.property.address,
				postalCode: data.property.postalCode,
				city: data.property.city,
				user: user
			}).save();
		}
		console.log('property: ', property)

		const stateOfPlay = await StateOfPlay.create({
			fullAddress: property.address + ', ' + property.postalCode + ' ' + property.city,// needed for search (issue nested search doesnt work)
			ownerFullName: owner.firstName + ' ' + owner.lastName,
			tenantsFullName: tenants.map(tenant => tenant.firstName + ' ' + tenant.lastName),
			user: user,
			owner: owner,
			representative: representative,
			tenants: tenants,
			property: property,
			out: data.out,
			rooms: JSON.stringify(data.rooms)
		}).save();
		console.log('stateOfPlay: ', stateOfPlay)

		// await stateOfPlay.save();
		return stateOfPlay;
	}
	
	@Authorized()
	@Mutation(() => Int)
	async updateStateOfPlay(@Arg("data") data: UpdateStateOfPlayInput, @Ctx() ctx: MyContext) {

		// @ts-ignore
		const user = await User.findOne({ id: ctx.userId })
		if (!user) return
		console.log('user: ', user)

		// @ts-ignore
		var owner = data.owner.id && await Owner.findOne({ id: data.owner.id })
		if (!owner) {
			owner = await Owner.create({
				firstName: data.owner.firstName,
				lastName: data.owner.lastName,
				user: user,
			}).save();
		}
		console.log('owner: ', owner)
		
		// @ts-ignore
		var representative = data.representative.id && await Representative.findOne({ id: data.representative.id })
		if (!representative) {
			representative = await Representative.create({
				firstName: data.representative.firstName,
				lastName: data.representative.lastName,
				user: user,
			}).save();
		}
		console.log('representative: ', representative)

		const tenants = []
		for(let i = 0; i < data.tenants.length; i++) {
			// @ts-ignore
			var tenant = data.tenants[i].id && await Tenant.findOne({ id: data.tenants[i].id })
			if (!tenant) {
				tenant = await Tenant.create({
					firstName: data.tenants[i].firstName,
					lastName: data.tenants[i].lastName,
					user: user,
				}).save();
			}
			tenants.push(tenant)
		}
		console.log('tenants[0]: ', tenants[0])
		
		// @ts-ignore
		var property = data.property.id && await Property.findOne({ id: data.property.id })
		if (!property) {
			property = await Property.create({
				address: data.property.address,
				postalCode: data.property.postalCode,
				city: data.property.city,
				user: user
			}).save();
		}
		console.log('property: ', property)

		const connection = getConnection();

		const stateOfPlay2 = await connection.getRepository(StateOfPlay).findOne(data.id);
		if (!stateOfPlay2) return 0

		stateOfPlay2.fullAddress = property.address + ', ' + property.postalCode + ' ' + property.city// needed for search (issue nested search doesnt work)
		stateOfPlay2.ownerFullName = owner.firstName + ' ' + owner.lastName
		// @ts-ignore
		stateOfPlay2.tenantsFullName = tenants.map(tenant => tenant.firstName + ' ' + tenant.lastName)
		stateOfPlay2.user = user
		stateOfPlay2.owner = owner
		stateOfPlay2.representative = representative
		// @ts-ignore
		stateOfPlay2.tenants = tenants
		stateOfPlay2.property = property
		stateOfPlay2.rooms = JSON.stringify(data.rooms)

		const ret = await connection.getRepository(StateOfPlay).save(stateOfPlay2)

		// const stateOfPlay = { affected: 0}
		console.log('stateOfPlay: ', ret)

		// if (stateOfPlay.affected !== 1) return 0

		return 1
	}

	@Authorized()
	@Mutation(() => Int)
	async deleteStateOfPlay(@Arg("data") data: DeleteStateOfPlayInput) {

		const stateOfPlay = await StateOfPlay.delete(data.stateOfPlayId)

		console.log('deleteStateOfPlay: ', stateOfPlay)

		if (stateOfPlay.affected !== 1) return 0

		return 1
	}

}
