import { Entity, PrimaryGeneratedColumn, BaseEntity, ManyToOne, /*JoinColumn, */ManyToMany, Column, JoinTable } from "typeorm";
import { ObjectType, Field, ID } from "type-graphql";

import { User } from "./User";
import { Property } from "./Property";
import { Owner } from "./Owner";
import { Representative } from "./Representative";
import { Tenant } from "./Tenant";

@ObjectType()
@Entity()
export class StateOfPlay extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: number;

  @Field()
  @Column()
  fullAddress: String;
  
  @Field()
  @Column()
  ownerFullName: String;
  
  @Field(() => [String])
  @Column()
  tenantsFullName: String;

  @Field(() => Owner)
  @ManyToOne(() => Owner, owner => owner.stateOfPlays)
  owner: Owner;
  
  @Field(() => Representative)
  @ManyToOne(() => Representative, representative => representative.stateOfPlays)
  representative: Representative;

  @Field(() => [Tenant])
  @ManyToMany(() => Tenant, tenant => tenant.stateOfPlays)
  @JoinTable()
  tenants: [Tenant];

  @Field(() => User)
  @ManyToOne(() => User, user => user.stateOfPlays)
  user: User;

  @Field(() => Property)
  @ManyToOne(() => Property, property => property.stateOfPlays, { cascade: true })
  // @JoinColumn({ name: "propertyId" })// TODO: utile pour la recherche nested ?
  property: Property;
}
