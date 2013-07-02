/*
 * AppArmor security module
 *
 * This file contains AppArmor file mediation function definitions.
 *
 * Copyright 2013 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, version 2 of the
 * License.
 *
 *
 * This is a file of helper macros, defines for backporting newer versions
 * of apparmor to older kernels
 */
#ifndef __AA_BACKPORT_H
#define __AA_BACKPORT_H

/* commit 496ad9aa8ef448058e36ca7a787c61f2e63f0f54 */
#define file_inode(FILE) ((FILE)->f_path.dentry->d_inode)

/* commit d2b31ca644fdc8704de3367a6a56a5c958c77f53 */
#define kuid_t uid_t
#define kgid_t gid_t

/* commit 2db81452931eb51cc739d6e495cf1bd4860c3c99 */
#define GLOBAL_ROOT_UID 0
#define from_kuid(X, UID) UID
#define uid_eq(X, Y) ((X) == (Y))

/* commit d007794a182bc072a7b7479909dbd0d67ba341be */
#include <linux/capability.h>
#include <linux/cred.h>
#include <linux/sched.h>
#include <linux/security.h>
static inline int cap_mmap_addr(unsigned long addr)
{
	int ret = 0;

	if (addr < dac_mmap_min_addr) {
		ret = cap_capable(current, current_cred(), &init_user_ns,
				  CAP_SYS_RAWIO, SECURITY_CAP_AUDIT);
		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
		if (ret == 0)
			current->flags |= PF_SUPERPRIV;
	}
	return ret;
}

/* commits: 259e5e6c75a910f3b5e656151dc602f53f9d7548
            c29bceb3967398cf2ac8bf8edf9634fdb722df7d
*/
#define LSM_UNSAFE_NO_NEW_PRIVS 0
/* turn no_new_prics into an always false expr so the compiler throws it away */
#define no_new_privs did_exec < 0

/* commit: 83d498569e9a7a4b92c4c5d3566f2d6a604f28c9 */
#define file_open dentry_open
#define apparmor_file_open apparmor_dentry_open

/* commit 7f70893173b056df691b2ee7546bb44fd9abae6a */
#define list_splice_init_rcu(L, H, S) list_splice_init_rcu_fixed((L), (H), (S))
static inline void list_splice_init_rcu_fixed(struct list_head *list,
					struct list_head *head,
					void (*sync)(void))
{
	struct list_head *first = list->next;
	struct list_head *last = list->prev;
	struct list_head *at = head->next;

	if (list_empty(list))
		return;

	/* "first" and "last" tracking list, so initialize it. */

	INIT_LIST_HEAD(list);

	/*
	 * At this point, the list body still points to the source list.
	 * Wait for any readers to finish using the list before splicing
	 * the list body into the new list.  Any new readers will see
	 * an empty list.
	 */

	sync();

	/*
	 * Readers are finished with the source list, so perform splice.
	 * The order is important if the new list is global and accessible
	 * to concurrent RCU readers.  Note that RCU readers are not
	 * permitted to traverse the prev pointers without excluding
	 * this function.
	 */

	last->next = at;
	rcu_assign_pointer(list_next_rcu(head), first);
	first->prev = head;
	at->prev = last;
}

#endif /* __AA_BACKPORT_H */
