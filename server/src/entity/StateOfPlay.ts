import { Entity, PrimaryGeneratedColumn, BaseEntity, ManyToOne, ManyToMany, Column, JoinTable } from "typeorm";
import { ObjectType, Field, ID } from "type-graphql";

import { User } from "./User";
import { Property } from "./Property";
import { Owner } from "./Owner";
import { Representative } from "./Representative";
import { Tenant } from "./Tenant";

// @ObjectType()
// class Decoration extends BaseEntity {
//   @Field()
//   type: String
  
//   @Field()
//   nature: String
  
//   @Field()
//   state: String
  
//   @Field()
//   comment: String
// }


// @ObjectType()
// class Room extends BaseEntity {
//   @Field()
//   name: String

//   @Field(() => [Decoration])
//   decorations: [Decoration]
// }

@ObjectType()
@Entity()
export class StateOfPlay extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: number

  @Field()
  @Column()
  fullAddress: String
  
  @Field()
  @Column()
  ownerFullName: String
  
  @Field(() => [String])
  @Column()
  tenantsFullName: String;

  @Field(() => String)
  @Column("simple-json")
  rooms: String
  
  @Field(() => String)
  @Column("simple-json")
  meters: String

  @Field(() => String)
  @Column("simple-json")
  insurance: String
  
  @Field(() => String)
  @Column()
  comments: String
  
  @Field(() => String)
  @Column()
  reserve: String

  @Field(() => Boolean)
  @Column()
  out: Boolean

  @Field(() => Owner)
  @ManyToOne(() => Owner, owner => owner.stateOfPlays)
  owner: Owner
  
  @Field(() => Representative)
  @ManyToOne(() => Representative, representative => representative.stateOfPlays)
  representative: Representative;

  @Field(() => [Tenant])
  @ManyToMany(() => Tenant, tenant => tenant.stateOfPlays)
  @JoinTable()
  tenants: [Tenant]

  @Field(() => User)
  @ManyToOne(() => User, user => user.stateOfPlays)
  user: User

  @Field(() => Property)
  @ManyToOne(() => Property, property => property.stateOfPlays, { cascade: true })
  property: Property
}
