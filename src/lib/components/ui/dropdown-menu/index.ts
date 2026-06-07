import { DropdownMenu as DropdownMenuPrimitive } from 'bits-ui';

import Root from './dropdown-menu.svelte';
import Trigger from './dropdown-menu-trigger.svelte';
import Group from './dropdown-menu-group.svelte';
import Content from './dropdown-menu-content.svelte';
import Item from './dropdown-menu-item.svelte';
import Separator from './dropdown-menu-separator.svelte';

export {
	Root,
	Trigger,
	Group,
	Content,
	Item,
	Separator,
	//
	Root as DropdownMenu,
	Trigger as DropdownMenuTrigger,
	Group as DropdownMenuGroup,
	Content as DropdownMenuContent,
	Item as DropdownMenuItem,
	Separator as DropdownMenuSeparator
};

export type { DropdownMenuRootProps } from 'bits-ui';
