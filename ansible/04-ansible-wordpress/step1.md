
Like we've already seen, you start by creating a simple playbook that shows that Ansible can run against your host machine.

We've already created a playbook.yml file, but it won't show up until you add code to it.

1\. Go ahead and list the contents of your working directory to confirm:

`ls`{{execute}}

2\. Now, you'll specify which hosts the playbook should run on, as well as a set of tasks to run. For now, you'll just implement the `ping` module for now, like before:

<pre class="file" data-filename="playbook.yml"><blockquote>

---
- hosts: all
  become: true
  tasks:
    - name: Make sure we can connect
      ping:
</blockquote></pre>

3\. So, now that you've added some code to the file, confirm it's present in your working directory:

`ls`{{execute}}

4\. At this point, you should run ansible-playbook to prove that you can connect to the host. We do that by running our playbook against our localhost, like before:

`ansible-playbook -i 'localhost,' -c local playbook.yml`{{execute HOST1}}

#### Installing PHP

1\. Now that you know Ansible will run, let’s install PHP. Add the following to your playbook in the tasks section:

<pre class="file" data-filename="playbook.yml" data-target="append"><blockquote>
  # PHP
    - name: Add the ondrej PHP PPA
      apt_repository: repo='ppa:ondrej/php'
</blockquote></pre>

>Note: Remember, PPA stands for Personal Package Archive and it's what's used to assist the installation process.

2\. Once that’s installed, the next step is to install PHP. As you’ve added a PPA, you’ll want to update the apt package cache:

<pre class="file" data-filename="playbook.yml" data-target="append"><blockquote>
    - name: Update the apt cache
      apt: update_cache=yes cache_valid_time=3600
    - name: Install PHP
      apt: name=php state=present
</blockquote></pre>

3\. Run Ansible again after adding these tasks, to make sure it is completed successfully.

`ansible-playbook -i 'localhost,' -c local playbook.yml`{{execute}}

>Note: If your playbook doesn't run successfully, the changes are it's just a syntax error. Check your code, make any needed changes, and then run Ansible again.

4\. Once you’ve successfully run your playbook, run `which php` to make sure that it yields something similar to the following:

`which php`{{execute}}

Output:

```
/usr/bin/php
```

5\. If that looks good, continue by installing all of the other PHP packages that you’ll need. Let’s use `with_items` to make the playbook easier to read though. So, delete the previous task "Install PHP", then copy and paste the following into its place in the playbook:

```
    - name: Install PHP
      apt: name={{item}} state=present
      with_items:
        - php
        - php-fpm
        - php-mysql
        - php-xml
```

>Note: You're only to change the "Install PHP" section! You're using the with_items to wrap your request and include additional PHP packages.

6\. Unfortunately, installing PHP also installs Apache2. You don’t want to use that in this exercise. There’s no way around this, but you can remove it as soon as it’s installed by adding the following task to your playbook:

<pre class="file" data-filename="playbook.yml" data-target="append"><blockquote>
    - name: Remove apache2
      apt: name=apache2 state=absent
</blockquote></pre>


7\. Also, because Apache automatically creates its own `index.html` file, you'll need to add the following to your playbook in oder to remove it.

<pre class="file" data-filename="playbook.yml" data-target="append"><blockquote>
    - name: Remove apache2 index.html
      file:
        state: absent
        path: /var/www/html/index.html
</blockquote></pre>

8\. Run Ansible once again to check functionality, before moving on:

`ansible-playbook -i 'localhost,' -c local playbook.yml`{{execute}}

Great job!
