/*
 * Copyright 2023-present Daleks Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

CREATE DATABASE IF NOT EXISTS risk DEFAULT CHARACTER SET = utf8mb4;

use risk;


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
SET NAMES utf8mb4;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE='NO_AUTO_VALUE_ON_ZERO', SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

DROP TABLE IF EXISTS `risk_accumulate`;

CREATE TABLE `risk_accumulate`
(
    `id`           bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`         varchar(128)        NOT NULL DEFAULT '' COMMENT '名称',
    `group_key`    varchar(1024)       NOT NULL DEFAULT '' COMMENT '分组key',
    `agg_key`      varchar(1024)       NOT NULL DEFAULT '' COMMENT '聚合key',
    `agg_function` varchar(64)         NOT NULL DEFAULT '' COMMENT '聚合函数',
    `time_window`  int(11)             NOT NULL DEFAULT '1' COMMENT '聚合窗口',
    `window_unit`  varchar(20)         NOT NULL DEFAULT 'MINUTES' COMMENT '窗口时间单位',
    `time_span`    int(11)             NOT NULL DEFAULT '1' COMMENT '聚合时间粒度',
    `span_unit`    varchar(20)         NOT NULL DEFAULT 'MINUTES' COMMENT '粒度时间单位',
    `window_type`  varchar(20)         NOT NULL DEFAULT 'FIXED' COMMENT '窗口类型,FIXED 固定, SLIDING 滑动',
    `script`       text                NOT NULL COMMENT '前置条件',
    `events`       varchar(1024)       NOT NULL DEFAULT '' COMMENT '关联的事件,逗号分隔',
    `remark`       varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`          varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`       varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`     varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time`  datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`  datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_name` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='累积因子';

DROP TABLE IF EXISTS `risk_atom_rule`;

CREATE TABLE `risk_atom_rule`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(64)         NOT NULL DEFAULT '' COMMENT '名称',
    `script`      text COMMENT '规则内容',
    `state`       varchar(16)         NOT NULL DEFAULT '' COMMENT '状态',
    `reply`       varchar(255)        NOT NULL DEFAULT '' COMMENT '话术',
    `return_json` varchar(2048)       NOT NULL DEFAULT '' COMMENT '返回数据',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_name` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='规则表';


DROP TABLE IF EXISTS `risk_business`;

CREATE TABLE `risk_business`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(128)        NOT NULL DEFAULT '' COMMENT '名称',
    `code`        varchar(128)        NOT NULL DEFAULT '' COMMENT 'code',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_code` (`code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='业务表';


DROP TABLE IF EXISTS `risk_event`;

CREATE TABLE `risk_event`
(
    `id`             bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`           varchar(128)        NOT NULL DEFAULT '' COMMENT '名称',
    `code`           varchar(128)        NOT NULL DEFAULT '' COMMENT '事件code',
    `business_code`  varchar(128)        NOT NULL DEFAULT '' COMMENT '业务code',
    `group_rules`    varchar(512)        NOT NULL DEFAULT '' COMMENT '规则组',
    `gray_groups`    varchar(512)        NOT NULL DEFAULT '' COMMENT '前置名单组',
    `reply`          varchar(512)        NOT NULL DEFAULT '' COMMENT '返回话术',
    `model`          text COMMENT '参数模型(json)',
    `rename_mapping` text COMMENT '参数重命名规则(json)',
    `topic`          varchar(256)        NOT NULL DEFAULT '' COMMENT '风控结果发送的topic',
    `remark`         varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`            varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`         varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`       varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time`    datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`    datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_code` (`code`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='风控事件单元';


DROP TABLE IF EXISTS `risk_function_config`;

CREATE TABLE `risk_function_config`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `func`        varchar(128)        NOT NULL DEFAULT '' COMMENT '函数名称',
    `parameters`  varchar(2048)       NOT NULL DEFAULT '' COMMENT '函数入参json格式',
    `result`      varchar(2048)       NOT NULL DEFAULT '' COMMENT '函数返回结果json',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_func` (`func`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='变量函数配置表';



DROP TABLE IF EXISTS `risk_gray_group`;

CREATE TABLE `risk_gray_group`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(128)        NOT NULL DEFAULT '' COMMENT '名单名称',
    `category`    varchar(128)        NOT NULL DEFAULT '' COMMENT '名单类别',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_name` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='名单组表';


DROP TABLE IF EXISTS `risk_gray_list`;

CREATE TABLE `risk_gray_list`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `type`        varchar(8)          NOT NULL DEFAULT 'BLACK' COMMENT '名单类型(BLACK=黑名单，WHITE=白名单)',
    `dimension`   varchar(64)         NOT NULL DEFAULT '' COMMENT '维度',
    `_value`      varchar(255)        NOT NULL DEFAULT '' COMMENT '维度值',
    `start_time`  timestamp           NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '生效时间',
    `expire_time` timestamp           NULL     DEFAULT NULL COMMENT '失效时间',
    `group_id`    bigint(20)          NOT NULL DEFAULT '0' COMMENT '名单分组ID',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_group_type_dim_value` (`group_id`, `type`, `dimension`, `_value`),
    KEY `idx_create_time` (`create_time`),
    KEY `idx_value` (`_value`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='名单表';


DROP TABLE IF EXISTS `risk_group_rule`;

CREATE TABLE `risk_group_rule`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(32)         NOT NULL DEFAULT '' COMMENT '名称',
    `script`      text COMMENT '前置条件',
    `state`       varchar(16)         NOT NULL DEFAULT '' COMMENT '状态',
    `reply`       varchar(255)        NOT NULL DEFAULT '' COMMENT '话术',
    `atom_rules`  varchar(2048)       NOT NULL DEFAULT '' COMMENT '规则',
    `return_json` varchar(2048)       NOT NULL DEFAULT '' COMMENT '返回数据(json)',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_name` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='规则组表';


DROP TABLE IF EXISTS `risk_parameter_mapping`;

CREATE TABLE `risk_parameter_mapping`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `event`       varchar(128)        NOT NULL DEFAULT '' COMMENT '事件',
    `config`      varchar(32)         NOT NULL DEFAULT '' COMMENT '配置项分类(VARIABLE=变量, ATOM_RULE=规则, GROUP_RULE=规则组, ACCUMULATE=累积因子, PUNISH=惩罚)',
    `config_id`   bigint(20)          NOT NULL DEFAULT '0' COMMENT '配置项id',
    `origin`      varchar(128)        NOT NULL DEFAULT '' COMMENT '原参数名称',
    `mapping`     varchar(128)        NOT NULL DEFAULT '' COMMENT '重写参数名称',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_event` (`event`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='参数映射表';



DROP TABLE IF EXISTS `risk_tag_config`;

CREATE TABLE `risk_tag_config`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(128)        NOT NULL DEFAULT '' COMMENT '名称',
    `color`       varchar(128)        NOT NULL DEFAULT '' COMMENT '颜色',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_name` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='标签配置表';


DROP TABLE IF EXISTS `risk_tag_relation`;

CREATE TABLE `risk_tag_relation`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `tag_id`      bigint(20)          NOT NULL DEFAULT '0' COMMENT '标签id',
    `config_id`   bigint(20)          NOT NULL DEFAULT '0' COMMENT '配置项id',
    `config_type` varchar(128)        NOT NULL DEFAULT '' COMMENT '配置项类型',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_tag_config` (`tag_id`, `config_id`, `config_type`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='标签关系表';



DROP TABLE IF EXISTS `risk_variable`;

CREATE TABLE `risk_variable`
(
    `id`          bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
    `name`        varchar(128)        NOT NULL DEFAULT '' COMMENT '变量名称',
    `func`        varchar(128)        NOT NULL DEFAULT '' COMMENT '函数名称',
    `parameters`  varchar(512)        NOT NULL DEFAULT '' COMMENT '函数入参json格式',
    `remark`      varchar(512)        NOT NULL DEFAULT '' COMMENT '备注',
    `ext`         varchar(512)        NOT NULL DEFAULT '' COMMENT '拓展信息',
    `author`      varchar(64)         NOT NULL DEFAULT '' COMMENT '创建人',
    `modifier`    varchar(64)         NOT NULL DEFAULT '' COMMENT '最后更新人',
    `create_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` datetime            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uniq_name` (`name`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='变量表';


INSERT INTO `risk_accumulate` (`name`, `group_key`, `agg_key`, `agg_function`, `time_window`, `window_unit`,
                               `time_span`, `span_unit`, `window_type`, `script`, `events`, `remark`)
VALUES ('loginTimes10Min', 'UserId', '', 'COUNT', 10, 'MINUTES', 1, 'MINUTES', 'FIXED', '', '4', '10分钟登录次数');


INSERT INTO `risk_atom_rule` (`id`, `name`, `script`, `state`, `reply`)
VALUES (1, '登录次数策略', 'loginTimes10Min > 3 && !whiteListHit', 'ENABLE', '登录次数过多，请稍后重试'),
       (2, '登录地域限制策略',
        'if(ClientIpDetail != null && ClientIpDetail.country != null && ClientIpDetail.country.contains(\'中国\')) {\n  return \"REJECT\"\n}',
        'ENABLE', '暂不支持外国登录');


INSERT INTO `risk_business` (`name`, `code`, `remark`)
VALUES ('支付', 'PAYMENT', ''),
       ('风控', 'RISK', '风控业务'),
       ('测试', 'RECHARGE_POST_SUCCESS', ''),
       ('用户', 'USER', '');


INSERT INTO `risk_event` (`id`, `name`, `code`, `business_code`, `group_rules`, `gray_groups`)
VALUES (1, '充值', 'RECHARGE', 'PAYMENT', '2', ''),
       (2, '交易', 'TRADE', 'PAYMENT', '', ''),
       (3, '提现', 'WITHDRAW', 'PAYMENT', '', ''),
       (4, '登录', 'LOGIN', 'USER', '1', '2,1');


INSERT INTO `risk_function_config` (`func`, `parameters`, `result`, `remark`)
VALUES ('whiteList', '[groupId:groupId, dimension:dimension, value:value]', '', '是否命中白名单'),
       ('blackList', '[groupId:groupId, dimension:dimension, value:value]', '', '是否命中黑名单');


INSERT INTO `risk_gray_group` (`id`, `name`, `category`, `remark`)
VALUES (1, '全局名单', 'system', ''),
       (2, '登录名单组', 'user', ''),
       (3, '限额充值名单组', 'user', ''),
       (4, '限额交易名单组', 'user', '');


INSERT INTO `risk_gray_list` (`type`, `dimension`, `_value`, `start_time`, `expire_time`, `group_id`, `remark`)
VALUES ('WHITE', 'USER_ID', '0x0001', '2023-01-01 00:00:00', NULL, 1, '测试'),
       ('BLACK', 'USER_ID', '0x0002', '2023-01-01 00:00:00', '2023-02-01 00:00:00', 1, ''),
       ('BLACK', 'USER_ID', '0x0003', '2023-01-01 00:00:00', NULL, 1, '');


INSERT INTO `risk_group_rule` (`id`, `name`, `script`, `state`, `reply`, `atom_rules`, `return_json`)
VALUES (1, '登录检查策略组', '', 'ENABLE', '请稍后重试', '1,2', ''),
       (2, '充值检查策略组', '', 'ENABLE', '', '', ''),
       (3, '交易检查策略组', '', 'ENABLE', '', '', ''),
       (4, '提现检查策略组', '', 'ENABLE', '', '', '');


INSERT INTO `risk_variable` (`name`, `func`, `parameters`, `remark`)
VALUES ('whiteListHit', 'whiteList', '[groupId:1, dimension:\"USER_ID\", value:UserId]', '是否命中全局白名单'),
       ('blackListHit', 'blackList', '[groupId:1, dimension:\"USER_ID\", value:UserId]', '是否命中全局黑名单');


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


